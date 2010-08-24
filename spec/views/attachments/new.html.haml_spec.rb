require 'spec_helper'

describe "attachments/new.html.haml" do
  before(:each) do
    assign(:attachment, stub_model(Attachment,
      :new_record? => true
    ))
  end

  it "renders new attachment form" do
    render

    rendered.should have_selector("form", :action => attachments_path, :method => "post") do |form|
    end
  end
end
