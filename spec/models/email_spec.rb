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
