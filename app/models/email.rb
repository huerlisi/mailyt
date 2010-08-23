class Email < ActiveRecord::Base
  scope :by_subject, proc {|value| where(:subject => value)}
  scope :by_text, proc {|value|
    where("(subject LIKE ?)", "%#{value}%")
  }
end
