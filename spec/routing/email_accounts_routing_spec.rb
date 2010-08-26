require "spec_helper"

describe EmailAccountsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/email_accounts" }.should route_to(:controller => "email_accounts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/email_accounts/new" }.should route_to(:controller => "email_accounts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/email_accounts/1" }.should route_to(:controller => "email_accounts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/email_accounts/1/edit" }.should route_to(:controller => "email_accounts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/email_accounts" }.should route_to(:controller => "email_accounts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/email_accounts/1" }.should route_to(:controller => "email_accounts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/email_accounts/1" }.should route_to(:controller => "email_accounts", :action => "destroy", :id => "1")
    end

  end
end
