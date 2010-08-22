class EmailsController < InheritedResources::Base
  has_scope :order
  
  def create
    create!{emails_path}
  end
end
