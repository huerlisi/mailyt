class EmailAccountsController < InheritedResources::Base
  respond_to :html, :js

  protected
    def collection
      @email_accounts ||= end_of_association_chain.paginate(:page => params[:page])
    end

  # Actions
  public

  def new
    @email = Email.new(:from => User.current.email)

    new!
  end
end
