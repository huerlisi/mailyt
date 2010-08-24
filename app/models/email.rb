class Email < ActiveRecord::Base
  # Associations
  belongs_to :in_reply_to, :class_name => 'Email'
  has_many :replies, :class_name => 'Email', :foreign_key => :in_reply_to
  
  # Scopes
  scope :by_subject, proc {|value| where(:subject => value)}
  scope :by_text, proc {|value|
    where("(subject LIKE :like) OR (date = :value) OR (\"to\" LIKE :like) OR (name LIKE :like) OR (body LIKE :like)", :value => value, :like => "%#{value}%")
  }

  def is_reply?
    !(in_reply_to.nil?)
  end
  
  def build_reply
    reply = Email.new(
      :in_reply_to => self,
      :subject     => "Re: " + subject,
      :body        => body.gsub(/^/, "> ")
    )
    return reply
  end
end
