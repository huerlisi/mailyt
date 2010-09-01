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
  
  describe "#sync_from_imap" do
    it "returns false if no email_account" do
      email = Email.new(:email_account => nil)
      email.sync_from_imap.should == false
    end
    
    it "returns false if no email_account" do
      email = Email.new(:email_account => nil)
      email.sync_to_imap.should == false
    end
  end
  
  context "threading" do
    describe "#calculate_thread_id" do
      let(:head) { Factory(:thread_head) }
      let(:child) { head.create_reply }
      let(:grand_child) { child.create_reply }

      it "should return id string when it has no parent" do
        head.calculate_thread_id.should == head.id
      end

      it "should return 'parent.id id' when it is a reply" do
        child.calculate_thread_id.should == [head.id, child.id].join(" ")
      end

      it "should return concatenated string of parent ids" do
        grand_child.calculate_thread_id.should == [head.id, child.id, grand_child.id].join(" ")
      end
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
  
  context "replies" do
    let(:original) { Email.new(:subject => "Original", :body => "Some text.") }

    describe "#build_reply" do
      subject { original.build_reply }
      
      specify { should be_kind_of Email }
      specify { should be_reply }
      its(:in_reply_to) { should == original }
      its(:subject) { should == "Re: Original" }
      its(:to) { should == original.from }
    end

    describe "#create_reply" do
      subject { original.create_reply }
      
      specify { should be_valid }
      specify { should be_persisted }
    end
  end
end
