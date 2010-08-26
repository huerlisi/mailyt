require 'spec_helper'

describe "email_accounts/edit.html.haml" do
  before(:each) do
    @email_account = assign(:email_account, stub_model(EmailAccount,
      :new_record? => false
    ))
  end

  it "renders the edit email_account form" do
    render

    rendered.should have_selector("form", :action => email_account_path(@email_account), :method => "post") do |form|
    end
  end
end
