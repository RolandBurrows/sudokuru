require 'minitest/autorun'

class Testify < MiniTest::Unit::TestCase

  def test_that_will_be_skipped
    skip "who tests the tester?"
  end

end
