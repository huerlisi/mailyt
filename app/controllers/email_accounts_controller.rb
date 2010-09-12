class EmailAccountsController < InheritedResources::Base
  # Aspects
  respond_to :html, :js
  include SentientController

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

  def create
    @email_account = EmailAccount.new(params[:email_account])
    @email_account.user = User.current
    
    create!
  end
end
