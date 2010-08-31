require 'vendor/plain_imap'

class EmailAccount < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Helpers
  def to_s
    return "" unless username.present? and server.present?
    
    return "%s@%s" % [username, server]
  end

  # IMAP
  # ====
  attr_reader :imap_connection
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
  end

  # Log out
  def close_imap_connection
    @imap_connection.logout
    begin
      @imap_connection.disconnect unless @imap_connection.disconnected?
    rescue
      Rails.logger.info("EmailAccount: Remote closed connection before I could disconnect.")
    end
  end
end
