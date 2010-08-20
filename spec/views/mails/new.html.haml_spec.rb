require 'spec_helper'

describe "mails/new.html.haml" do
  before(:each) do
    assign(:mail, stub_model(Mail,
      :new_record? => true
    ))
  end

  it "renders new mail form" do
    render

    rendered.should have_selector("form", :action => mails_path, :method => "post") do |form|
    end
  end
end
