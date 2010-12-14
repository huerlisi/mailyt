class EmailAccountsController < InheritedResources::Base
  # Aspects
  respond_to :html, :js

  protected
    def collection
      @email_accounts ||= end_of_association_chain.paginate(:page => params[:page])
    end

  # Actions
  public

  def new
    @email = Email.new(:from => current_user.email, :user => current_user)

    new!
  end

  def create
    @email_account = EmailAccount.new(params[:email_account])
    @email_account.user = current_user
    
    create!
  end
end
