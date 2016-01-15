require 'minitest/autorun'

describe "sudokuru" do

  it "should process the default input file when no specific file is given" do
    # ARGV = nil
    load "sudokuru.rb"
    assert_equal $script_failed, "no"
  end

end

