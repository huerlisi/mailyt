require 'ostruct'

class EmailsController < InheritedResources::Base
  has_scope :order
  has_scope :by_text, :as => :text

  def create
    create!{emails_path}
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
end
