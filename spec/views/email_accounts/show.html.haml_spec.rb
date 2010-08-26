require 'spec_helper'

describe "email_accounts/show.html.haml" do
  before(:each) do
    @email_account = assign(:email_account, stub_model(EmailAccount))
  end

  it "renders attributes in <p>" do
    render
  end
end
