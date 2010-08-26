require 'spec_helper'

describe Email do
  it "is valid" do
    Email.new.should be_valid
  end
end
