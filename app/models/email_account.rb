require 'vendor/plain_imap'

class EmailAccount < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  # Associations
  belongs_to :user
  has_many :emails
  has_many :folders

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

  def sync_folder_from_imap(folder_name)
    imap_connection.select(folder_name)
    mailyt_folder = Folder.find_by_title(folder_name)
    
    imap_uids = imap_connection.uid_search('UNDELETED')
    mailyt_uids = mailyt_folder.emails.all.collect{|email| email.uid}.compact
    
    uids_to_fetch = (imap_uids - mailyt_uids)
    uids_to_delete = (mailyt_uids - imap_uids)
    uids_to_sync = (imap_uids & mailyt_uids)
    
    for uid in uids_to_fetch
      email = create_email_from_imap(uid, mailyt_folder)
      email.sync_from_imap
      email.save

      # Should be callbacks
      email.thread_id
      email.thread_date
    end
    for uid in uids_to_delete
      delete_email_from_mailyt(uid)
    end
    for uid in uids_to_sync
      email = mailyt_folder.emails.where(:uid => uid).first
      email.sync_from_imap
      email.save
    end
  end

  def sync_from_imap
    sync_folder_from_imap('INBOX')
  end

  def sync_folders_from_imap
    imap_folder_names = imap_connection.list('', '*').collect{|folder| folder.name}
    mailyt_folder_names = folders.all.collect{|folder| folder.title}
    
    folder_names_to_fetch = (imap_folder_names - mailyt_folder_names)
    folder_names_to_delete = (mailyt_folder_names - imap_folder_names)
    
    for folder_name in folder_names_to_fetch
      create_folder_from_imap(folder_name)
    end
    for folder_name in folder_names_to_delete
      delete_folder_from_mailyt(folder_name)
    end
  end
  
  def create_folder_from_imap(foldername)
    imap_folder = imap_connection.list('', foldername).first
    folder = Folder.build_from_imap(imap_folder)
    folder.email_account = self
    folder.save
    
    return folder
  end
  
  def create_email_from_imap(uid, folder)
    # Use examine to select folder so we don't accidentialy update the seen flag
    imap_connection.examine(folder.title)
    # Fetch message
    msg = imap_connection.uid_fetch(uid,'RFC822').first.attr['RFC822']
    
    email = Basic.receive(msg, uid, self)
    email.folder = folder

    return email
  end
  
  def delete_email_from_mailyt(uid)
    email = Email.where(:uid => uid, :email_account_id => self.id).first
    
    # Set uid to nil so that this won't trigger an imap delete again
    email.uid = nil
    email.destroy
  end
end
