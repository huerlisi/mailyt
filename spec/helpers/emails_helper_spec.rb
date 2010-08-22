require 'spec_helper'

describe EmailsHelper do
  describe "mail_address" do
    it "shows name and email in <>" do
      helper.mail_address("test@example.com", "Test").should == "Test <test@example.com>"
    end
    
    it "shows only email if no name given" do
      helper.mail_address("test@example.com").should == "test@example.com"
    end

    it "shows only email if name is blank" do
      helper.mail_address("test@example.com", "").should == "test@example.com"
      helper.mail_address("test@example.com", " ").should == "test@example.com"
    end

    it "strips surrounding whitespace from name" do
      helper.mail_address("test@example.com", " Test ").should == "Test <test@example.com>"
    end

    it "leaves whitespace inside name intact" do
      helper.mail_address("test@example.com", " Test Person ").should == "Test Person <test@example.com>"
    end

    it "strips surrounding whitespace from email" do
      helper.mail_address(" test@example.com ", "Test").should == "Test <test@example.com>"
    end
  end
end
