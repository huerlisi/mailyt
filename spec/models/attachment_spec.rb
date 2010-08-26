require 'spec_helper'

describe Attachment do
  it "is valid" do
    Attachment.new.should be_valid
  end
end
