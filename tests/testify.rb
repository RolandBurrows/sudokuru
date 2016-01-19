require 'minitest/autorun'

describe "sudokuru" do

	def capture_stdout(&block)
	  original_stdout = $stdout
	  $stdout = fake = StringIO.new
	  begin
	    yield
	  rescue SystemExit => e
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
		output.must_include "File contents:"
		output.must_include "is a square"
		output.must_include "data is properly formatted"
		output.must_include "rows contain no duplicate values"
		output.must_include "columns contain no duplicate values"
		output.must_include "SOLUTION"
  end

  it "should detect that a given input file doesnt exist" do
    ARGV[0] = "./puzzles/jabberwocky.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "jabberwocky.txt"
    output.must_include "ERROR"
    output.must_include "given file doesn't exist"
  end

  it "should detect that puzzle dimensions are mismatched" do
    ARGV[0] = "./puzzles/dimensionality_mismatch.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Row length does not match column height"
  end

  it "should detect that puzzle file is empty" do
    ARGV[0] = "./puzzles/empty.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "file is empty"
  end

  it "should process the given input file and confirm every allowed blank character" do
    ARGV[0] = "./puzzles/every_allowed_character.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "every_allowed_character.txt"
    output.must_include "data is properly formatted"
    output.must_include "Determining box uniqueness is for"
  end

  it "should detect that puzzle file has non-allowed characters" do
    ARGV[0] = "./puzzles/non_allowed_character.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "The character (z) is not allowed"
  end

  it "should detect that puzzle file has allowed, but inappropriate, characters" do
    ARGV[0] = "./puzzles/nums_too_large.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "The puzzle is 2x2, so the number (3) is not allowed"
  end

  it "should detect that puzzle file has duplicate characters in a row" do
    ARGV[0] = "./puzzles/duplicates_in_row.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Row 3 (_33) contains duplicate values"
  end

  it "should detect that puzzle file has duplicate characters in a column" do
    ARGV[0] = "./puzzles/duplicates_in_column.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Column 4 (4412) contains duplicate values"
  end

  it "should detect that puzzle file has non-unique boxes" do
    ARGV[0] = "./puzzles/non_unique_boxes.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Box 6 (423791846) contains duplicate values"
  end

end

