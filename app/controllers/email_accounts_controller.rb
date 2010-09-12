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
end
