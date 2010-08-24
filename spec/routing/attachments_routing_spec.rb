require "spec_helper"

describe AttachmentsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/attachments" }.should route_to(:controller => "attachments", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/attachments/new" }.should route_to(:controller => "attachments", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/attachments/1" }.should route_to(:controller => "attachments", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/attachments/1/edit" }.should route_to(:controller => "attachments", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/attachments" }.should route_to(:controller => "attachments", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/attachments/1" }.should route_to(:controller => "attachments", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/attachments/1" }.should route_to(:controller => "attachments", :action => "destroy", :id => "1")
    end

  end
end
