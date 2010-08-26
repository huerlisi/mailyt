require "spec_helper"

describe Basic do
  describe "text" do
    let(:email) {
      email = mock_model(Email)
      email.should_receive(:subject).and_return("Subject")
      email.should_receive(:to).and_return("to@example.org")
      email.should_receive(:from).and_return("from@example.com")
      email.should_receive(:attachments).and_return([])
      email.should_receive(:body).and_return("Body")

      email
    }
    let(:mail) { Basic.text(email) }

    it "renders the headers" do
      mail.subject.should eq("Subject")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Body")
    end
  end

end
