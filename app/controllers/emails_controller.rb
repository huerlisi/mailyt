require 'ostruct'

class EmailsController < InheritedResources::Base
  # Aspects
  respond_to :html, :js
  include SentientController
  
  # Scopes
  has_scope :order, :default => 'thread_date DESC, thread_id'
  has_scope :by_text, :as => :text

  protected
    def collection
      @emails ||= end_of_association_chain.by_user(current_user).paginate(:page => params[:page], :per_page => params[:per_page])
    end

  # Actions
  public
  def new
    @email = Email.new(params[:email])
    @email.from = User.current.email
    @email.attachments.build
    
    new!
  end
  
  def create
    create!{emails_path}
    
    Basic.text(@email).deliver
  end

  def show
    @email = Email.find(params[:id])
    @email.seen = true
    @email.save
    
    show!
  end
  
  # GET /emails/search
  # GET /emails/search.xml
  def search
    params[:per_page] ||= 25
    
    params[:text] ||= params[:search][:text] || params[:search][:query] if params[:search]
    @query = params[:text]
    
    
    index!
  end

  def index
    params[:per_page] ||= 25
    
    params[:text] ||= params[:search][:text] || params[:search][:query] if params[:search]
    @query = params[:text]
    
    index!
  end

  # GET /emails/1/reply
  def reply
    original = Email.find(params[:id])
    @email = original.build_reply
    @email.from = User.current.email
    
    new!
  end
end
