require 'spec_helper'

describe "emails/new.html.haml" do
  include Devise::TestHelpers
  before do
    sign_in Factory.create(:user)
  end

  before(:each) do
    assign(:email, stub_model(Email,
      :new_record? => true
    ))
  end

  it "renders new email form" do
    render

    rendered.should have_selector("form", :action => emails_path, :method => "post") do |form|
      form.should have_selector("input[type=text]#email_to")
      form.should have_selector("input[type=text]#email_subject")
      form.should have_selector("textarea#email_body")

      form.should have_selector("input[type=submit]#email_submit")
    end
  end
end
