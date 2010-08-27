require 'spec_helper'

describe User do
  specify { should_not be_valid }

  describe "#to_s" do
    let(:user) { User.new }
    
    it "should return empty string when new" do
      user.should_receive(:email).at_least(1).and_return(nil)
      user.to_s { should == "" }

      user.should_receive(:email).at_least(1).and_return("")
      user.to_s { should == "" }
    end

    it "should return email when set" do
      user.should_receive(:email).at_least(1).and_return("test@example.com")
      user.to_s { should == "test@example.com" }
    end
  end
end
