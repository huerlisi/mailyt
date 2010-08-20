require 'spec_helper'

describe "mails/show.html.haml" do
  before(:each) do
    @mail = assign(:mail, stub_model(Mail))
  end

  it "renders attributes in <p>" do
    render
  end
end
