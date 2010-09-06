require 'spec_helper'

describe Folder do
  specify {should be_valid}
  
  describe ".build_from_imap" do
    let(:node_folder) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Node1") }
    let(:parent_folder) { Net::IMAP::MailboxList.new([:Haschildren], ".", "Parent1") }
    let(:child_folder_1) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Parent1.Child1") }
    let(:child_folder_2) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Parent1.Child21") }
    
    let(:folder) { Folder.build_from_imap(node_folder) }
    subject { folder }
    specify { should be_a Folder }
    specify { should be_a_new_record }
    its(:title) { should == "Node1" }
  end
end
