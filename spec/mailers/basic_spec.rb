require "spec_helper"

describe Basic do
  describe "text" do
    let(:mail) { Basic.text }

    it "renders the headers" do
      mail.subject.should eq("Text")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
