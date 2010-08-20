require 'spec_helper'

describe "emails/show.html.haml" do
  before(:each) do
    @email = assign(:email, stub_model(Email))
  end

  it "renders attributes in <p>" do
    render
  end
end
