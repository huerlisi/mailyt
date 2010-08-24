class Email < ActiveRecord::Base
  scope :by_subject, proc {|value| where(:subject => value)}
  scope :by_text, proc {|value|
    where("(subject LIKE :like) OR (date = :value) OR (\"to\" LIKE :like) OR (name LIKE :like) OR (body LIKE :like)", :value => value, :like => "%#{value}%")
  }

  def build_reply
    reply = Email.new(
      :subject => "Re: " + subject,
      :body    => body.gsub(/^/, "> ")
    )
    return reply
  end
end
