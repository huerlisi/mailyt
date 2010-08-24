class AttachmentsController < InheritedResources::Base
  respond_to :html, :js

  protected
    def collection
      @attachments ||= end_of_association_chain.paginate(:page => params[:page])
    end
end
