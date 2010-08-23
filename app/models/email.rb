class Email < ActiveRecord::Base
  scope :by_subject, lambda {|value| where(:subject => value)}
end
