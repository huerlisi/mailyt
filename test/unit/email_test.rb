require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  should "be valid" do
    assert Email.new.valid?
  end
end
