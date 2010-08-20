require "spec_helper"

describe MailsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/mails" }.should route_to(:controller => "mails", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/mails/new" }.should route_to(:controller => "mails", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/mails/1" }.should route_to(:controller => "mails", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/mails/1/edit" }.should route_to(:controller => "mails", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/mails" }.should route_to(:controller => "mails", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/mails/1" }.should route_to(:controller => "mails", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/mails/1" }.should route_to(:controller => "mails", :action => "destroy", :id => "1")
    end

  end
end
