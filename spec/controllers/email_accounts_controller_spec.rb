require 'spec_helper'

describe EmailAccountsController do
  include Devise::TestHelpers
  before do
    user = Factory.create(:user)
    sign_in user
    user.make_current
  end

  def mock_email_account(stubs={})
    @mock_email_account ||= mock_model(EmailAccount, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all email_accounts as @email_accounts" do
      controller.stub(:collection) {controller.instance_variable_set('@email_accounts', [mock_email_account])}
      get :index
      assigns(:email_accounts).should eq([mock_email_account])
    end
  end

  describe "GET show" do
    it "assigns the requested email_account as @email_account" do
      EmailAccount.stub(:find).with("37") { mock_email_account }
      get :show, :id => "37"
      assigns(:email_account).should be(mock_email_account)
    end
  end

  describe "GET new" do
    it "assigns a new email_account as @email_account" do
      EmailAccount.stub(:new) { mock_email_account }
      get :new
      assigns(:email_account).should be(mock_email_account)
    end
  end

  describe "GET edit" do
    it "assigns the requested email_account as @email_account" do
      EmailAccount.stub(:find).with("37") { mock_email_account }
      get :edit, :id => "37"
      assigns(:email_account).should be(mock_email_account)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created email_account as @email_account" do
        EmailAccount.stub(:new).with({'these' => 'params'}) { mock_email_account(:save => true) }
        post :create, :email_account => {'these' => 'params'}
        assigns(:email_account).should be(mock_email_account)
      end

      it "redirects to the created email_account" do
        EmailAccount.stub(:new) { mock_email_account(:save => true) }
        post :create, :email_account => {}
        response.should redirect_to(email_account_url(mock_email_account))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved email_account as @email_account" do
        EmailAccount.stub(:new).with({'these' => 'params'}) { mock_email_account(:save => false) }
        post :create, :email_account => {'these' => 'params'}
        assigns(:email_account).should be(mock_email_account)
      end

      it "re-renders the 'new' template" do
        EmailAccount.stub(:new) { mock_email_account(:save => false) }
        post :create, :email_account => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested email_account" do
        EmailAccount.should_receive(:find).with("37") { mock_email_account }
        mock_email_account.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :email_account => {'these' => 'params'}
      end

      it "assigns the requested email_account as @email_account" do
        EmailAccount.stub(:find) { mock_email_account(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:email_account).should be(mock_email_account)
      end

      it "redirects to the email_account" do
        EmailAccount.stub(:find) { mock_email_account(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(email_account_url(mock_email_account))
      end
    end

    describe "with invalid params" do
      it "assigns the email_account as @email_account" do
        EmailAccount.stub(:find) { mock_email_account(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:email_account).should be(mock_email_account)
      end

      it "re-renders the 'edit' template" do
        EmailAccount.stub(:find) { mock_email_account(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested email_account" do
      EmailAccount.should_receive(:find).with("37") { mock_email_account }
      mock_email_account.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the email_accounts list" do
      EmailAccount.stub(:find) { mock_email_account }
      delete :destroy, :id => "1"
      response.should redirect_to(email_accounts_url)
    end
  end

end
