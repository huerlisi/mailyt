require 'spec_helper'

describe Email do
  before {
    DateTime.stub!(:now).and_return(DateTime.parse('2001-01-01 08:15'))
  }
  
  context "when new" do
    specify { should be_valid }
    specify { should_not be_reply }
    its(:date) { should == "2001-01-01 08:15" }
    its(:to_s) { should == " -> : " }
  end

  describe "#new" do
    it "sets date to now by default" do
      Email.new.date.should == DateTime.now
    end

    it "uses date from hash" do
      Email.new(:date => '2010-02-02').date.should == '2010-02-02'
    end

    it "uses from from hash" do
      Email.new(:from => 'test@example.com').from.should == 'test@example.com'
    end
  end
  
  it "#sync_from_imap returns false if no email_account" do
    email = Email.new(:email_account => nil)
    email.sync_from_imap.should == false
  end
  
  it "#sync_to_imap returns false if no email_account" do
    email = Email.new(:email_account => nil)
    email.sync_to_imap.should == false
  end
  
  context "threading" do
    it "#calculate_thread_id should be id when it has no parent" do
      email = Factory(:simple_email)
      email.calculate_thread_id.should == email.id
    end

    it "#calculate_thread_id should be parent.id + id when it his a reply" do
      head = Factory(:thread_head)
      child = head.build_reply
      child.save
      child.calculate_thread_id.should == [head.id, child.id].join(" ")
    end

    it "#calculate_thread_id should concatenated string of parent ids" do
      head = Factory(:thread_head)
      child = head.build_reply
      child.save
      grand_child = child.build_reply
      grand_child.save
      grand_child.calculate_thread_id.should == [head.id, child.id, grand_child.id].join(" ")
    end
  end
  
  it "#imap_connection delegates to it's email_account" do
    email_account = mock_model(EmailAccount)
    connection = double
    email_account.should_receive(:imap_connection).and_return(connection)

    email = Email.new(:email_account => email_account)
    email.send(:imap_connection).should == connection
  end

  context "with imap_connection" do
    let(:connection) {
      connection = mock
      connection
    }
    
    let(:email) {
      email = Email.new(:uid => 1)
      email.stub(:imap_connection).and_return(connection)
      email
     }

    it "#imap_message" do
      imap_answer = double
      imap_answer.stub(:attr).and_return({'RFC822' => 'test'})
      connection.should_receive(:uid_fetch).with(1, 'RFC822').and_return([imap_answer])
      email.send(:imap_message).should == 'test'
    end
  end
  
  describe "#reply?" do
    let(:email) {Email.new}

    it "is false if email has no assigned in_reply_to" do
      email.should_receive(:in_reply_to).and_return(nil)
      email.should_not be_reply
    end

    it "is true if email has an assigned in_reply_to" do
      email.should_receive(:in_reply_to).and_return(mock(Email))
      email.should be_reply
    end
  end
  
  describe "email returned by #build_reply" do
    let(:original) { Email.new(:subject => "Original", :body => "Some text.") }
    subject { original.build_reply }
    
    specify { should be_kind_of Email }
    specify { should be_reply }
    its(:in_reply_to) { should == original }
    its(:subject) { should == "Re: Original" }
    its(:to) { should == original.from }
  end
end
