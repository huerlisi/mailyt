require 'spec_helper'

describe "emails/index.html.haml" do
  before(:each) do
    assign(:emails, [
      stub_model(Email),
      stub_model(Email)
    ])
  end

#  it "renders a list of emails" do
#    render
    
#    rendered.should have_selector("table")
#  end
end
