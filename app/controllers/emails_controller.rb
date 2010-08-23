require 'ostruct'

class EmailsController < InheritedResources::Base
  has_scope :order
  has_scope :by_subject, :as => :subject
  
  def create
    create!{emails_path}
  end
end
