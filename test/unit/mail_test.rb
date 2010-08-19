require 'test_helper'

class MailTest < ActiveSupport::TestCase
  should "be valid" do
    assert Mail.new.valid?
  end
end
