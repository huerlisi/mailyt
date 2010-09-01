require 'spec_helper'

describe "emails/_email.html.haml" do
  before(:each) do
    @view.should_receive(:email).at_least(1).and_return(stub_model(Email))
  end

  it "shows subject" do
    render
    rendered.should have_selector(".email .subject")
  end

  it "shows delection link" do
    render
    rendered.should have_selector("a[title='Destroy'][href='#{email_path(@view.email)}'][data-method='delete'][data-remote='true']")
  end

  it "shows reply link" do
    render
    rendered.should have_selector("a[title='Reply'][href='#{reply_email_path(@view.email)}']")
  end
end
