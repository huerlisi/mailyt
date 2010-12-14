class Email < ActiveRecord::Base
  # Folders
  SENT = 'Sent'
  
  # Associations
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
  
  # Actions
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

  # Threading
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

  # IMAP
  include EmailConcern::Imap
end
