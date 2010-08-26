require 'spec_helper'

describe Email do
  specify { should be_valid }
  
  context "when new" do
    specify { should_not be_reply }
  end
end
