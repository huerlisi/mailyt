require 'spec_helper'

describe "email_accounts/new.html.haml" do
  before(:each) do
    assign(:email_account, stub_model(EmailAccount,
      :new_record? => true
    ))
  end

  it "renders new email_account form" do
    render

    rendered.should have_selector("form", :action => email_accounts_path, :method => "post") do |form|
    end
  end
end
