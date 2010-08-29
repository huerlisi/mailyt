require 'ostruct'

class EmailsController < InheritedResources::Base
  # Aspects
  include SentientController
  
  # Scopes
  has_scope :order, :default => 'date DESC'
  has_scope :by_text, :as => :text

  def new
    @email = Email.new(params[:email])
    @email.attachments.build
    
    new!
  end
  
  def create
    create!{emails_path}
    
    Basic.text(@email).deliver
  end

  # GET /emails/search
  # GET /emails/search.xml
  def search
    params[:per_page] ||= 25
    
    params[:search] ||= {}
    params[:search][:text] ||= params[:search][:query]
    @query = params[:search][:text]
    
    @emails = apply_scopes(Email, params[:search].merge(params)).paginate :page => params[:page], :per_page => params[:per_page]
    
    index!
  end

  def index
    params[:per_page] ||= 25
    
    params[:search] ||= {}
    params[:search][:text] ||= params[:search][:query]
    @query = params[:search][:text]
    
    @emails = apply_scopes(Email, params[:search].merge(params)).paginate :page => params[:page], :per_page => params[:per_page]
    
    index!
  end

  # GET /emails/1/reply
  def reply
    original = Email.find(params[:id])
    @email = original.build_reply
    
    new!
  end
end
