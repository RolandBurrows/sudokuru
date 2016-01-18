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
    output.must_include "No file specified"
		output.must_include "input.txt"
		# output.must_include "SOLUTION"
  end

  it "should detect that a given input file doesnt exist" do
    ARGV[0] = "./puzzles/jabberwocky.txt"
    proc { capture_stdout {load "sudokuru.rb" }}.must_raise SystemExit
    # proc { capture_stdout { load "sudokuru.rb" }}.must_output "ERROR"
  end

  it "should detect that puzzle dimensions are identical" do
    ARGV[0] = nil
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "height and length are equivalent"
  end

  it "should detect that puzzle dimensions are mismatched" do
    ARGV[0] = "./puzzles/dimensionality_mismatch.txt"
    proc { capture_stdout {load "sudokuru.rb" }}.must_raise SystemExit
    # proc { capture_stdout { load "sudokuru.rb" }}.must_output "ERROR"
  end

  it "should detect that puzzle file is empty" do
    ARGV[0] = "./puzzles/empty.txt"
    proc { capture_stdout {load "sudokuru.rb" }}.must_raise SystemExit
    # proc { capture_stdout { load "sudokuru.rb" }}.must_output "ERROR"
  end

  it "should process the given input file and confirm every allowed blank character" do
    ARGV[0] = "./puzzles/2x2.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "2x2.txt"
    output.must_include "File contents:"
    output.must_include "data is properly formatted"
  end

  it "should detect that puzzle file has non-allowed characters" do
    ARGV[0] = "./puzzles/non_allowed_character.txt"
    proc { capture_stdout {load "sudokuru.rb" }}.must_raise SystemExit
    # proc { capture_stdout { load "sudokuru.rb" }}.must_output "ERROR"
  end

  it "should detect that puzzle file has allowed, but inappropriate, characters" do
    ARGV[0] = "./puzzles/nums_too_large.txt"
    proc { capture_stdout {load "sudokuru.rb" }}.must_raise SystemExit
    # proc { capture_stdout { load "sudokuru.rb" }}.must_output "ERROR"
  end

  it "should detect that puzzle file has duplicate characters in a row" do
    ARGV[0] = "./puzzles/duplicates_in_row.txt"
    proc { capture_stdout {load "sudokuru.rb" }}.must_raise SystemExit
    # proc { capture_stdout { load "sudokuru.rb" }}.must_output "ERROR"
  end

  it "should detect that puzzle file has duplicate characters in a column" do
    ARGV[0] = "./puzzles/duplicates_in_column.txt"
    proc { capture_stdout {load "sudokuru.rb" }}.must_raise SystemExit
    # proc { capture_stdout { load "sudokuru.rb" }}.must_output "ERROR"
  end

  it "should detect that puzzle file has non-unique boxes" do
    ARGV[0] = "./puzzles/non_unique_boxes.txt"
    proc { capture_stdout {load "sudokuru.rb" }}.must_raise SystemExit
    # proc { capture_stdout { load "sudokuru.rb" }}.must_output "ERROR"
  end

end

