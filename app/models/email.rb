class Email < ActiveRecord::Base
  # Associations
  belongs_to :email_account
  belongs_to :user
  belongs_to :in_reply_to, :class_name => 'Email'
  has_many :replies, :class_name => 'Email', :foreign_key => :in_reply_to_id
  has_many :attachments
  accepts_nested_attributes_for :attachments
  
  # Scopes
  scope :by_user, proc {|value| where(:user_id => value)}
  scope :by_subject, proc {|value| where(:subject => value)}
  scope :by_text, proc {|value|
    where("(subject LIKE :like) OR (date = :value) OR (\"to\" LIKE :like) OR (name LIKE :like) OR (body LIKE :like)", :value => value, :like => "%#{value}%")
  }

  def initialize(attributes = nil)
    attributes ||= {}
    defaults = {:date => DateTime.now, :user => User.current}

    super(defaults.merge(attributes))
  end
  
  def to_s
    "%s -> %s: %s" % [from, to, subject]
  end
  
  def reply?
    !(in_reply_to.nil?)
  end
  
  def build_reply
    reply = Email.new(
      :in_reply_to => self,
      :to          => self.from,
      :subject     => "Re: " + subject,
      :body        => body.gsub(/^/, "> ")
    )
    return reply
  end

  # IMAP
  def sync_from_imap
    email_account.establish_imap_connection
    imap_connection = imap_connection
    imap_connection.select('INBOX')

    self.seen = imap_connection.uid_fetch(uid, 'FLAGS').first.attr['FLAGS'].include?(:Seen)

    email_account.close_imap_connection
  end

  after_update :sync_to_imap
  after_destroy :sync_to_imap
  
  def sync_to_imap
    email_account.establish_imap_connection
    imap_connection.select('INBOX')

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
    
    email_account.close_imap_connection
  end

  protected
  def imap_connection
    email_account.imap_connection
  end

  def imap_message
    connection = imap_connection
    return connection.uid_fetch(uid, 'RFC822').first.attr['RFC822']
  end
end
