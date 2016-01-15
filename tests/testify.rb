require 'minitest/autorun'

describe "sudokuru" do

	def capture_stdout(&block)
	  original_stdout = $stdout
	  $stdout = fake = StringIO.new
	  begin
	    yield
	  ensure
	    $stdout = original_stdout
	  end
	  fake.string
	end

  it "should process the default input file when no specific file is given" do
    ARGV[0] = nil
    output = capture_stdout { load "sudokuru.rb" }
    assert_equal (output.include? "No file specified"), true
		assert_equal (output.include? "input.txt"), true
  end

  it "should detect that puzzle dimensions are identical" do
    ARGV[0] = nil
    output = capture_stdout { load "sudokuru.rb" }
    assert_equal (output.include? "height and length are equivalent"), true
  end

end

