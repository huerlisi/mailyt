require 'spec_helper'

describe "attachments/edit.html.haml" do
  before(:each) do
    @attachment = assign(:attachment, stub_model(Attachment,
      :new_record? => false
    ))
  end

  it "renders the edit attachment form" do
    render

    rendered.should have_selector("form", :action => attachment_path(@attachment), :method => "post") do |form|
    end
  end
end
