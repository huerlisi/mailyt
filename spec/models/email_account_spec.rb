require 'spec_helper'

describe EmailAccount do
  specify { should be_valid }
  its(:port) { should == 143 }
  its(:ssl) { should == false }
  its(:use_login) { should == false }
  its(:authentication) { should == 'PLAIN' }
  
  describe "#to_s" do
    let(:email_account) { EmailAccount.new }
    
    it "should return empty string when new" do
      email_account.stub(:username).and_return(nil)
      email_account.stub(:server).and_return(nil)
      email_account.to_s { should == "" }

      email_account.stub(:username).and_return("")
      email_account.stub(:server).and_return("")
      email_account.to_s { should == "" }
    end

    it "should return email when set" do
      email_account.should_receive(:username).at_least(1).and_return("test")
      email_account.should_receive(:server).at_least(1).and_return("mail.example.com")
      email_account.to_s { should == "test@mail.example.com" }
    end
  end
end
