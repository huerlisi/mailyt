require 'spec_helper'

describe "attachments/index.html.haml" do
  before(:each) do
    assign(:attachments, [
      stub_model(Attachment),
      stub_model(Attachment)
    ].paginate({:page => 1, :per_page => 30}))
  end

  it "renders a list of attachments" do
    render
  end
end
