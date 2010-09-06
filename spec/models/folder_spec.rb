require 'spec_helper'

describe Folder do
  specify {should be_valid}
  
  it "#imap_connection delegates to it's email_account" do
    email_account = mock_model(EmailAccount)
    connection = double
    email_account.should_receive(:imap_connection).and_return(connection)

    folder = Folder.new(:email_account => email_account)
    folder.send(:imap_connection).should == connection
  end

  context "with imap connection" do
    let(:imap_connection_mock) { mock.as_null_object }
    before do
      subject.stub(:imap_connection).and_return(imap_connection_mock)
    end

    describe ".build_from_imap" do
      let(:node_folder) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Node1") }
      let(:parent_folder) { Net::IMAP::MailboxList.new([:Haschildren], ".", "Parent1") }
      let(:child_folder_1) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Parent1.Child1") }
      let(:child_folder_2) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Parent1.Child21") }
      before do
        responses = {
          "EXISTS" => {-1 => 10 },
          "UNSEEN" => {-1 => nil }
        }
        imap_connection_mock.stub(:responses).and_return(responses)
      end
      
      let(:folder) { Folder.build_from_imap(node_folder) }
      subject { folder }
      specify { should be_a Folder }
      specify { should be_a_new_record }
      its(:title) { should == "Node1" }
      its(:email_count) { should == 10 }
      its(:unseen_count) { should == 0 }
    end
  end
end
