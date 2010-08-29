class Email < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :in_reply_to, :class_name => 'Email'
  has_many :replies, :class_name => 'Email', :foreign_key => :in_reply_to_id
  has_many :attachments
  accepts_nested_attributes_for :attachments
  
  # Scopes
  scope :by_subject, proc {|value| where(:subject => value)}
  scope :by_text, proc {|value|
    where("(subject LIKE :like) OR (date = :value) OR (\"to\" LIKE :like) OR (name LIKE :like) OR (body LIKE :like)", :value => value, :like => "%#{value}%")
  }

  def initialize(attributes = nil)
    attributes ||= {}
    defaults = {:date => DateTime.now, :from => User.current.email}

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
end
