class EmailAccountsController < InheritedResources::Base
  respond_to :html, :js

  protected
    def collection
      @email_accounts ||= end_of_association_chain.paginate(:page => params[:page])
    end
end
