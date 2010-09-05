require 'vendor/plain_imap'

class EmailAccount < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  # Associations
  belongs_to :user
  has_many :emails

  # Helpers
  def to_s
    return "" unless username.present? and server.present?
    
    return "%s@%s" % [username, server]
  end

  # IMAP
  # ====
  def imap_connection
    # Lookup thread local cached connection
    Thread.current[:imap_connections] ||= {}
    connection = Thread.current[:imap_connections][id]

    # Create new connection if no good one is available
    if connection.nil? || connection.disconnected?
      connection = establish_imap_connection

      # Cache connection 
      Thread.current[:imap_connections][id] = connection
    end
    
    return connection
  end
  
  def port
    143
  end
  
  def ssl
    false
  end
  
  def use_login
    false
  end

  def authentication
    'PLAIN'
  end
  
  # Open connection and login to server
  def establish_imap_connection
    timeout_call = (RUBY_VERSION < '1.9.0') ? "SystemTimer.timeout_after(15.seconds) do" : "Timeout::timeout(15) do"
    
    eval("#{timeout_call}
            @imap_connection = Net::IMAP.new(server, port, ssl)
            if use_login
              @imap_connection.login(username, password)
            else
              @imap_connection.authenticate(authentication, username, password)
            end
          end")
    return @imap_connection
  end

  # Log out
  def close_imap_connection
    imap_connection.logout
    begin
      imap_connection.disconnect unless imap_connection.disconnected?
    rescue
      Rails.logger.info("EmailAccount: Remote closed connection before I could disconnect.")
    end
  end

  def sync_from_imap
    imap_connection.select('INBOX')
    
    imap_uids = imap_connection.uid_search('UNDELETED')
    mailyt_uids = emails.select(:uid).all.collect{|email| email.uid}.compact
    
    uids_to_fetch = (imap_uids - mailyt_uids)
    uids_to_delete = (mailyt_uids - imap_uids)
    uids_to_sync = (imap_uids & mailyt_uids)
    
    for uid in uids_to_fetch
      create_email_from_imap(uid)
    end
    for uid in uids_to_delete
      delete_email_from_mailyt(uid)
    end
    for uid in uids_to_sync
      email = emails.where(:uid => uid).first
      email.sync_from_imap
      email.save
    end
  end

  def create_email_from_imap(uid)
    # Save seen flag
    seen = imap_connection.uid_fetch(uid,'FLAGS').first.attr['FLAGS'].include?(:Seen)
    # Fetch message
    msg = imap_connection.uid_fetch(uid,'RFC822').first.attr['RFC822']
    # Restore seen flag
    msg = imap_connection.uid_fetch(uid, 'RFC822').first.attr['RFC822']
    if seen
      imap_connection.uid_store(uid, "+FLAGS", [:Seen])
    else
      imap_connection.uid_store(uid, "-FLAGS", [:Seen])
    end
    
    return Basic.receive(msg, uid, self)
  end
  
  def delete_email_from_mailyt(uid)
    email = Email.where(:uid => uid, :email_account_id => self.id).first
    
    # Set uid to nil so that this won't trigger an imap delete again
    email.uid = nil
    email.destroy
  end
end
