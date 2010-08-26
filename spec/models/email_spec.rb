require 'spec_helper'

describe Email do
  before { DateTime.stub!(:now).and_return(DateTime.parse('2001-01-01 08:15'))}

  context "when new" do
    specify { should be_valid }
    specify { should_not be_reply }
    its(:date) { should == "2001-01-01 08:15" }
    its(:to_s) { should == " -> : " }
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
