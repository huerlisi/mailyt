require 'spec_helper'

describe MailsController do

  def mock_mail(stubs={})
    @mock_mail ||= mock_model(Mail, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all mails as @mails" do
      Mail.stub(:all) { [mock_mail] }
      get :index
      assigns(:mails).should eq([mock_mail])
    end
  end

  describe "GET show" do
    it "assigns the requested mail as @mail" do
      Mail.stub(:find).with("37") { mock_mail }
      get :show, :id => "37"
      assigns(:mail).should be(mock_mail)
    end
  end

  describe "GET new" do
    it "assigns a new mail as @mail" do
      Mail.stub(:new) { mock_mail }
      get :new
      assigns(:mail).should be(mock_mail)
    end
  end

  describe "GET edit" do
    it "assigns the requested mail as @mail" do
      Mail.stub(:find).with("37") { mock_mail }
      get :edit, :id => "37"
      assigns(:mail).should be(mock_mail)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created mail as @mail" do
        Mail.stub(:new).with({'these' => 'params'}) { mock_mail(:save => true) }
        post :create, :mail => {'these' => 'params'}
        assigns(:mail).should be(mock_mail)
      end

      it "redirects to the created mail" do
        Mail.stub(:new) { mock_mail(:save => true) }
        post :create, :mail => {}
        response.should redirect_to(mail_url(mock_mail))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved mail as @mail" do
        Mail.stub(:new).with({'these' => 'params'}) { mock_mail(:save => false) }
        post :create, :mail => {'these' => 'params'}
        assigns(:mail).should be(mock_mail)
      end

      it "re-renders the 'new' template" do
        Mail.stub(:new) { mock_mail(:save => false) }
        post :create, :mail => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested mail" do
        Mail.should_receive(:find).with("37") { mock_mail }
        mock_mail.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :mail => {'these' => 'params'}
      end

      it "assigns the requested mail as @mail" do
        Mail.stub(:find) { mock_mail(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:mail).should be(mock_mail)
      end

      it "redirects to the mail" do
        Mail.stub(:find) { mock_mail(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(mail_url(mock_mail))
      end
    end

    describe "with invalid params" do
      it "assigns the mail as @mail" do
        Mail.stub(:find) { mock_mail(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:mail).should be(mock_mail)
      end

      it "re-renders the 'edit' template" do
        Mail.stub(:find) { mock_mail(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested mail" do
      Mail.should_receive(:find).with("37") { mock_mail }
      mock_mail.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the mails list" do
      Mail.stub(:find) { mock_mail }
      delete :destroy, :id => "1"
      response.should redirect_to(mails_url)
    end
  end

end
