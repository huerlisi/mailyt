require 'spec_helper'

describe "mails/new.html.haml" do
  before(:each) do
    assign(:mail, stub_model(Mail,
      :new_record? => true
    ))
  end

  it "renders new mail form" do
    render

    rendered.should have_selector("form", :action => mails_path, :method => "post") do |form|
      form.should have_selector("input[type=text]#mail_to")
      form.should have_selector("input[type=text]#mail_subject")
      form.should have_selector("textarea#mail_body")

      form.should have_selector("input[type=submit]#mail_submit")
    end
  end
end
