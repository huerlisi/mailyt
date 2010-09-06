class Folder < ActiveRecord::Base
  # Associations
  has_many :emails
  belongs_to :parent, :class_name => 'Folder'
  belongs_to :email_account

  # Constructors
  def self.build_from_imap(imap_folder)
    folder = Folder.new
    
    folder.title = imap_folder.name
    return folder
  end

  def email_count
    imap_connection.examine(title)
    imap_connection.responses["EXISTS"][-1] || 0
  end

  def unseen_count
    imap_connection.examine(title)
    imap_connection.responses["UNSEEN"][-1] || 0
  end

  # IMAP
  protected
  delegate :imap_connection, :to => :email_account
end
