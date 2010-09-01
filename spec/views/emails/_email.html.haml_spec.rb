require 'spec_helper'

describe "emails/_email.html.haml" do
  let(:email) { stub_model(Email) }
  before do
    @view.should_receive(:email).at_least(1).and_return(email)
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

  context "for seen emails" do
    before do
      email.should_receive(:seen?).at_least(1).and_return(true)
    end
  
    it "email container should have class .seen" do
      render
      rendered.should have_selector(".email.seen")
    end

    it "shows mark as unread link" do
      render
      rendered.should have_selector("a[title='Mark as unread'][href='#{mark_as_unread_email_path(@view.email)}']")
    end
  end
end
