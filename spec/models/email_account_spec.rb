require 'spec_helper'

describe EmailAccount do
  specify { should be_valid }
  its(:port) { should == 143 }
  its(:ssl) { should == false }
  its(:use_login) { should == false }
  its(:authentication) { should == 'PLAIN' }
  
  describe "#to_s" do
    it "should return empty string when new" do
      subject.stub(:username).and_return(nil)
      subject.stub(:server).and_return(nil)
      to_s { should == "" }

      subject.stub(:username).and_return("")
      subject.stub(:server).and_return("")
      to_s { should == "" }
    end

    it "should return email when set" do
      subject.should_receive(:username).at_least(1).and_return("test")
      subject.should_receive(:server).at_least(1).and_return("mail.example.com")
      subject.to_s { should == "test@mail.example.com" }
    end
  end
  
  describe "#establish_imap_connection" do
    let(:connection_mock) { mock }
    before do
      Net::IMAP.should_receive(:new).and_return(connection_mock)
      connection_mock.stub(:authenticate)
    end
    
    it "should call authenticate" do
      connection_mock.should_receive(:authenticate)
      subject.establish_imap_connection
    end
    
    it "should return imap_connection" do
      subject.establish_imap_connection.should == connection_mock
    end
  end

  describe "#close_imap_connection" do
    let(:connection_mock) { mock }
    before do
      subject.stub(:imap_connection).and_return(connection_mock)
    end
    
    it "should call logout and disconnect" do
      connection_mock.should_receive(:disconnected?).and_return(false)
      connection_mock.should_receive(:logout)
      connection_mock.should_receive(:disconnect)
      subject.close_imap_connection
    end
  end
    
  describe "#imap_connection" do
    let(:connection_mock) { mock(:disconnected? => false).as_null_object }
    let(:connection_mock_2) { mock.as_null_object }

    before do
      subject.stub(:establish_imap_connection).and_return(connection_mock)
      Thread.current[:imap_connections] = {}
      subject.id = 1
    end

    it "should call establish_connection if no connection is cached" do
      subject.should_receive(:establish_imap_connection).and_return(connection_mock)
      subject.imap_connection
    end
    
    it "should return thread local connection if available" do
      Thread.current[:imap_connections][1] = connection_mock
      subject.imap_connection.should == connection_mock
    end

    it "should call established_connection if cached one is disconnected" do
      Thread.current[:imap_connections][1] = connection_mock
      connection_mock.stub(:disconnected?).and_return(true)

      subject.should_receive(:establish_imap_connection).and_return(connection_mock_2)
      subject.imap_connection.should == connection_mock_2
    end

    it "should call establish_imap_connection only once" do
      subject.should_receive(:establish_imap_connection).and_return(connection_mock)
      connection_mock.stub(:disconnected).and_return(false)
      
      connection = subject.imap_connection
      connection.should == subject.imap_connection
    end
    
    it "should call establish_imap_connection only once on multiple instances of same EmailAccount" do
      subject.save
      email_account_1 = EmailAccount.find(subject.id)
      email_account_2 = EmailAccount.find(subject.id)

      email_account_1.should_receive(:establish_imap_connection).and_return(connection_mock)
      connection_1 = email_account_1.imap_connection
      
      email_account_2.should_not_receive(:establish_imap_connection)
      connection_2 = email_account_2.imap_connection
      connection_1.should == connection_2
    end
  end
  
  context "with imap connection" do
    let(:imap_connection_mock) { mock.as_null_object }
    before do
      subject.stub(:imap_connection).and_return(imap_connection_mock)
    end
    
    describe "#sync_from_imap" do
      before do
        imap_connection_mock.should_receive(:uid_search).and_return([1,2,3,4])
        
        subject.stub_chain(:emails, :all, :collect, :compact).and_return([3,4,5,6])
        subject.stub_chain(:emails, :where, :first).and_return(mock_model(Email).as_null_object)
        subject.stub(:delete_email_from_mailyt)
        subject.stub(:create_email_from_imap)
      end
      
      it "should select INBOX" do
        imap_connection_mock.should_receive(:select).with('INBOX')
        subject.sync_from_imap
      end
      
      it "should use imap and mailyt uids to calculate fetches" do
        subject.sync_from_imap
      end
      
      it "should call create_email_from_imap for each mail only on imap" do
        subject.should_receive(:create_email_from_imap).with(1)
        subject.should_receive(:create_email_from_imap).with(2)
        stub(:delete_email_from_mailyt)
        subject.sync_from_imap
      end

      it "should call deleted_in_imap for each mail only in mailyt" do
        subject.should_receive(:delete_email_from_mailyt).with(5)
        subject.should_receive(:delete_email_from_mailyt).with(6)
        
        subject.sync_from_imap
      end

      it "should call Email#sync_from_imap for each mail in both imap and mailyt" do
        email = mock_model(Email).as_null_object
        subject.stub_chain(:emails, :where, :first).and_return(email)
        email.should_receive(:sync_from_imap).exactly(2)
        
        subject.sync_from_imap
      end
    end

    let(:imap_seen_message) {
      message = mock.as_null_object
      message.stub(:attr).and_return({
        'FLAGS' => [:Seen],
        'RFC822' => 'RFC822'
      })
      message
    }
    let(:imap_unseen_message) {
      message = mock.as_null_object
      message.stub(:attr).and_return({
        'FLAGS' => [],
        'RFC822' => 'RFC822'
      })
      message
    }
    
    before do
      imap_connection_mock.stub(:uid_fetch).with(1, 'RFC822').and_return([imap_seen_message])
      imap_connection_mock.stub(:uid_fetch).with(1, 'FLAGS').and_return([imap_seen_message])
    end
    
    describe "#create_email_from_imap" do
      it "should create an Email" do
        subject.create_email_from_imap(1).should be_kind_of(Email)
      end
      
      it "should fetch RFC822 from IMAP" do
        imap_connection_mock.should_receive(:uid_fetch).with(1, 'RFC822').and_return([imap_seen_message])
        subject.create_email_from_imap(1)
      end

      it "should let re-set seen flag if set" do
        imap_connection_mock.should_receive(:uid_store).with(1, "+FLAGS", [:Seen])
        subject.create_email_from_imap(1)
      end

      it "should let delete seen flag if not set before fetching" do
        imap_connection_mock.stub(:uid_fetch).with(1, 'FLAGS').and_return([imap_unseen_message])
        imap_connection_mock.should_receive(:uid_store).with(1, "-FLAGS", [:Seen])
        subject.create_email_from_imap(1)
      end
      
      it "should call Basic.receive" do
        Basic.should_receive(:receive).with('RFC822', 1, subject)
        subject.create_email_from_imap(1)
      end
    end
  
    describe "#deleted_in_imap" do
      it "should not trigger Email#sync_from_imap" do
        email = mock_model(Email).as_null_object
        Email.stub_chain(:where, :first).and_return(email)
        email.should_not_receive(:sync_from_imap)
        
        subject.delete_email_from_mailyt(1)
      end
    end
    
    let(:node_folder) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Node1") }
    let(:parent_folder) { Net::IMAP::MailboxList.new([:Haschildren], ".", "Parent1") }
    let(:child_folder_1) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Parent1.Child1") }
    let(:child_folder_2) { Net::IMAP::MailboxList.new([:Hasnochildren], ".", "Parent1.Child21") }
    describe "#create_folder_from_imap" do
      it "should create a Folder" do
        imap_connection_mock.should_receive(:list).with('', 'INBOX').and_return([node_folder])
        
        folder = subject.create_folder_from_imap('INBOX')
        folder.should be_a Folder
        folder.should_not be_a_new_record
      end
    end

    describe "#sync_folders_from_imap" do
      context "on first sync" do
        before do
          imap_connection_mock.stub(:list).with('', '*').and_return([node_folder, parent_folder, child_folder_1, child_folder_2])
        end
        
        it "should create all folders" do
          expect {
            subject.sync_folders_from_imap
          }.to change{ Folder.count }.by(4)
        end
      end
    end
  end
end
