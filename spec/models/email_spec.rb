require 'spec_helper'

describe Email do
  it "is valid" do
    Email.new.should be_valid
  end
  
  context "is new" do
    let(:email) {Email.new}
    
    it "should not be a reply" do
      email.should_not be_reply
    end
  end
end
