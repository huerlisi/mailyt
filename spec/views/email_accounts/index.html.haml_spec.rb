require 'spec_helper'

describe "email_accounts/index.html.haml" do
  before(:each) do
    assign(:email_accounts, [
      stub_model(EmailAccount),
      stub_model(EmailAccount)
    ])
  end

  it "renders a list of email_accounts" do
    render
  end
end
