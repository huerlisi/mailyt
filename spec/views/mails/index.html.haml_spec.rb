require 'spec_helper'

describe "mails/index.html.haml" do
  before(:each) do
    assign(:mails, [
      stub_model(Mail),
      stub_model(Mail)
    ])
  end

  it "renders a list of mails" do
    render
    
    rendered.should have_selector("table")
  end
end
