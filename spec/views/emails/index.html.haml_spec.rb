require 'spec_helper'

describe "emails/index.html.haml" do
  before(:each) do
    assign(:emails, [
      stub_model(Email),
      stub_model(Email)
    ].paginate({:page => 1, :per_page => 30}))
  end

  it "renders a list of emails" do
    render
    
    rendered.should have_selector("ul.list")
    rendered.should have_selector("li.email")
  end
end
