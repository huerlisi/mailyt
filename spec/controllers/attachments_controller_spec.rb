require 'spec_helper'

describe AttachmentsController do

  def mock_attachment(stubs={})
    @mock_attachment ||= mock_model(Attachment, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all attachments as @attachments" do
      Attachment.stub(:all) { [mock_attachment] }
      get :index
      assigns(:attachments).should eq([mock_attachment])
    end
  end

  describe "GET show" do
    it "assigns the requested attachment as @attachment" do
      Attachment.stub(:find).with("37") { mock_attachment }
      get :show, :id => "37"
      assigns(:attachment).should be(mock_attachment)
    end
  end

  describe "GET new" do
    it "assigns a new attachment as @attachment" do
      Attachment.stub(:new) { mock_attachment }
      get :new
      assigns(:attachment).should be(mock_attachment)
    end
  end

  describe "GET edit" do
    it "assigns the requested attachment as @attachment" do
      Attachment.stub(:find).with("37") { mock_attachment }
      get :edit, :id => "37"
      assigns(:attachment).should be(mock_attachment)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created attachment as @attachment" do
        Attachment.stub(:new).with({'these' => 'params'}) { mock_attachment(:save => true) }
        post :create, :attachment => {'these' => 'params'}
        assigns(:attachment).should be(mock_attachment)
      end

      it "redirects to the created attachment" do
        Attachment.stub(:new) { mock_attachment(:save => true) }
        post :create, :attachment => {}
        response.should redirect_to(attachment_url(mock_attachment))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved attachment as @attachment" do
        Attachment.stub(:new).with({'these' => 'params'}) { mock_attachment(:save => false) }
        post :create, :attachment => {'these' => 'params'}
        assigns(:attachment).should be(mock_attachment)
      end

      it "re-renders the 'new' template" do
        Attachment.stub(:new) { mock_attachment(:save => false) }
        post :create, :attachment => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested attachment" do
        Attachment.should_receive(:find).with("37") { mock_attachment }
        mock_attachment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :attachment => {'these' => 'params'}
      end

      it "assigns the requested attachment as @attachment" do
        Attachment.stub(:find) { mock_attachment(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:attachment).should be(mock_attachment)
      end

      it "redirects to the attachment" do
        Attachment.stub(:find) { mock_attachment(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(attachment_url(mock_attachment))
      end
    end

    describe "with invalid params" do
      it "assigns the attachment as @attachment" do
        Attachment.stub(:find) { mock_attachment(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:attachment).should be(mock_attachment)
      end

      it "re-renders the 'edit' template" do
        Attachment.stub(:find) { mock_attachment(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested attachment" do
      Attachment.should_receive(:find).with("37") { mock_attachment }
      mock_attachment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the attachments list" do
      Attachment.stub(:find) { mock_attachment }
      delete :destroy, :id => "1"
      response.should redirect_to(attachments_url)
    end
  end

end
