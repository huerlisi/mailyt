require 'spec_helper'

describe Email do
  before { DateTime.stub!(:now).and_return(DateTime.parse('2001-01-01 08:15'))}
  context "when new" do
    specify { should be_valid }
    specify { should_not be_reply }
    its(:date) { should == "2001-01-01 08:15" }
  end
end
