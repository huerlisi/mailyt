require 'spec_helper'

describe "mails/edit.html.haml" do
  before(:each) do
    @mail = assign(:mail, stub_model(Mail,
      :new_record? => false
    ))
  end

  it "renders the edit mail form" do
    render

    rendered.should have_selector("form", :action => mail_path(@mail), :method => "post") do |form|
    end
  end
end
