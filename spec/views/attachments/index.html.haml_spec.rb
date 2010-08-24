require 'spec_helper'

describe "attachments/index.html.haml" do
  before(:each) do
    assign(:attachments, [
      stub_model(Attachment),
      stub_model(Attachment)
    ])
  end

  it "renders a list of attachments" do
    render
  end
end
