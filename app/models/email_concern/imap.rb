module EmailConcern::Imap
  extend ActiveSupport::Concern
  
  included do
    belongs_to :email_account
    after_update :sync_to_imap
    after_destroy :sync_to_imap
    delegate :imap_connection, :to => :email_account
  end
  
  def sync_from_imap
    return false unless email_account
    
    imap_connection.select(folder.title)

    self.seen = imap_connection.uid_fetch(uid, 'FLAGS').first.attr['FLAGS'].include?(:Seen)
  end

  def sync_to_imap
    return false unless email_account && uid
    
    imap_connection.select(folder.title)

    if seen?
      imap_connection.uid_store(uid, '+FLAGS', [:Seen])
    else
      imap_connection.uid_store(uid, '-FLAGS', [:Seen])
    end

    if destroyed?
      imap_connection.uid_copy(uid, 'Trash')
      imap_connection.uid_store(uid, '+FLAGS', [:Deleted])
    else
      imap_connection.uid_store(uid, '-FLAGS', [:Deleted])
    end
  end

  def imap_message
    return imap_connection.uid_fetch(uid, 'RFC822').first.attr['RFC822']
  end
  
  def message=(value)
    self.message_id = value.message_id
    self.imap_message = value.to_s
  end

  def imap_message=(value)
    imap_connection.append(folder.title, value, [:Seen])
  end
end
