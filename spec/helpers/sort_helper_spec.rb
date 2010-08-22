require 'spec_helper'

describe SortHelper do
  before(:each) do
    helper.stub(:link_to)
  end
  
  it "uses a th tag" do
    helper.sort_header("test").should match("<th")
  end

  it "uses localized column as content" do
    helper.stub(:t_attr).and_return("translated")
    
    helper.sort_header("test").should match("translated")
  end

  it "accepts symbols as column" do
    helper.stub(:t_attr).with(:test).and_return("translated")
    
    helper.sort_header(:test).should match("translated")
  end

end
