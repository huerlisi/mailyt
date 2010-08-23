require 'spec_helper'

describe EmailsController do

  def mock_email(stubs={})
    @mock_email ||= mock_model(Email, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all emails as @emails" do
      pending
      Email.stub(:all) { [mock_email] }
      get :index
      assigns(:emails).should eq([mock_email])
    end
  end

  describe "filtered index" do
    it "assigns all mails matching subject as @emails" do
      Email.stub(:by_subject).with("subject") { [mock_email] }
      get :index, :search => { :subject => "subject" }
      assigns(:emails).should eq([mock_email])
    end
  end
  
  describe "GET show" do
    it "assigns the requested email as @email" do
      Email.stub(:find).with("37") { mock_email }
      get :show, :id => "37"
      assigns(:email).should be(mock_email)
    end
  end

  describe "GET new" do
    it "assigns a new email as @email" do
      Email.stub(:new) { mock_email }
      get :new
      assigns(:email).should be(mock_email)
    end
  end

  describe "GET edit" do
    it "assigns the requested email as @email" do
      Email.stub(:find).with("37") { mock_email }
      get :edit, :id => "37"
      assigns(:email).should be(mock_email)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created email as @email" do
        Email.stub(:new).with({'these' => 'params'}) { mock_email(:save => true) }
        post :create, :email => {'these' => 'params'}
        assigns(:email).should be(mock_email)
      end

      it "redirects to the created email" do
        Email.stub(:new) { mock_email(:save => true) }
        post :create, :email => {}
        response.should redirect_to(emails_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved email as @email" do
        Email.stub(:new).with({'these' => 'params'}) { mock_email(:save => false) }
        post :create, :email => {'these' => 'params'}
        assigns(:email).should be(mock_email)
      end

      it "re-renders the 'new' template" do
        Email.stub(:new) { mock_email(:save => false) }
        post :create, :email => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested email" do
        Email.should_receive(:find).with("37") { mock_email }
        mock_email.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :email => {'these' => 'params'}
      end

      it "assigns the requested email as @email" do
        Email.stub(:find) { mock_email(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:email).should be(mock_email)
      end

      it "redirects to the email" do
        Email.stub(:find) { mock_email(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(email_url(mock_email))
      end
    end

    describe "with invalid params" do
      it "assigns the email as @email" do
        Email.stub(:find) { mock_email(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:email).should be(mock_email)
      end

      it "re-renders the 'edit' template" do
        Email.stub(:find) { mock_email(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested email" do
      Email.should_receive(:find).with("37") { mock_email }
      mock_email.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the emails list" do
      Email.stub(:find) { mock_email }
      delete :destroy, :id => "1"
      response.should redirect_to(emails_url)
    end
  end

end
