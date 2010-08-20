class EmailsController < InheritedResources::Base
  def create
    create!{emails_path}
  end
end
