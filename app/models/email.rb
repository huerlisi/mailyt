class Email < ActiveRecord::Base
  # Folders
  SENT = 'Sent'
  
  # Associations
  belongs_to :email_account
  belongs_to :folder
  belongs_to :user
  belongs_to :in_reply_to, :class_name => 'Email'
  has_many :replies, :class_name => 'Email', :foreign_key => :in_reply_to_id
  has_many :attachments
  accepts_nested_attributes_for :attachments
  
  # Scopes
  scope :seen, where(:seen => true)
  scope :unseen, where(:seen => false)
  scope :threaded, order(:thread_id)
  scope :by_user, proc {|value| where(:user_id => value)}
  scope :by_folder, proc {|value| where(:folder_id => value)}
  scope :by_subject, proc {|value| where(:subject => value)}
  scope :by_text, proc {|value|
    where("(subject LIKE :like) OR (date = :value) OR (\"to\" LIKE :like) OR (name LIKE :like) OR (body LIKE :like)", :value => value, :like => "%#{value}%")
  }

  # Constructor
  def initialize(attributes = nil)
    attributes ||= {}
    defaults = {:date => DateTime.now}

    super(defaults.merge(attributes))
  end

  # Helpers
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

  def create_reply
    reply = build_reply
    reply.save
    return reply
  end

  def calculate_thread_id
    return id unless reply?
    
    return [in_reply_to.calculate_thread_id, id].join(' ')
  end
  
  def thread_id
    update_attribute(:thread_id, calculate_thread_id) unless self[:thread_id]

    return self[:thread_id]
  end
  after_save :thread_id
  
  def calculate_thread_date
    return date if replies.empty?
    
    thread_dates = replies.collect{|reply| reply.calculate_thread_date}
    return (thread_dates + [date]).max
  end
  
  def thread_date
    update_attribute(:thread_date, calculate_thread_date) unless self[:thread_date]

    return self[:thread_date]
  end
  after_save :thread_date
  
  def sync_from_imap
    return false unless email_account
    
    imap_connection.select(folder.title)

    self.seen = imap_connection.uid_fetch(uid, 'FLAGS').first.attr['FLAGS'].include?(:Seen)
  end

  after_update :sync_to_imap
  after_destroy :sync_to_imap
  
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

  protected
  delegate :imap_connection, :to => :email_account

  public
  def imap_message
    return imap_connection.uid_fetch(uid, 'RFC822').first.attr['RFC822']
  end
  
  def message=(value)
    self.message_id = value.message_id
    self.imap_message = value.to_s
  end

  def imap_message=(value)
    imap_connection.append(SENT, value, [:Seen])
  end
end
