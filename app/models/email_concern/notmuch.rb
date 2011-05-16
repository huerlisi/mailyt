module EmailConcern::Notmuch
  extend ActiveSupport::Concern
  
  included do
    belongs_to :email_account
    after_update :sync_to_notmuch
    after_destroy :sync_to_notmuch
  end
  
  def sync_from_notmuch
    self.seen = !(Notmuch::Message.tags(uid).include?('unread')
    self.destroyed = (Notmuch::Message.tags(uid).include?('deleted')
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
