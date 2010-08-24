require 'spec_helper'

describe "attachments/show.html.haml" do
  before(:each) do
    @attachment = assign(:attachment, stub_model(Attachment))
  end

  it "renders attributes in <p>" do
    render
  end
end
