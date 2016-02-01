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

  # SOLVING FLOWS

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
		output.must_include "SUCCESS"
		output.must_include "Solution found in:"
  end

  it "should solve a 2x2 puzzle" do
    ARGV[0] = "./puzzles/2x2.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "2x2.txt"
    output.must_include "SUCCESS"
  end

  # POSITIVE FLOWS

  it "should detect naked singles within rows" do
    ARGV[0] = "./test_files/naked_singles_rows.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Naked single (2) detected on row 1"
    output.must_include "Naked single (3) detected on row 2"
    output.must_include "Naked single (1) detected on row 3"
    output.must_include "Modified puzzle data"
  end

  it "should detect naked singles within columns" do
    ARGV[0] = "./test_files/naked_singles_columns.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Naked single (2) detected on column 1"
    output.must_include "Naked single (3) detected on column 2"
    output.must_include "Naked single (1) detected on column 3"
    output.must_include "Modified puzzle data"
  end

    it "should detect naked singles within boxes" do
    ARGV[0] = "./test_files/naked_singles_boxes.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Naked single (3) detected in box 3"
    output.must_include "Naked single (5) detected in box 5"
    output.must_include "Naked single (7) detected in box 7"
    output.must_include "Modified puzzle data"
  end

  it "should determine the starting slice to be a row" do
    ARGV[0] = "./test_files/starting_row.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Starting slice is row 3, with 2 of 4 elements filled."
  end

  it "should determine the starting slice to be a column" do
    ARGV[0] = "./test_files/starting_column.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Starting slice is column 4, with 2 of 4 elements filled."
  end

  it "should determine the starting point" do
    ARGV[0] = "./test_files/starting_index.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Starting slice is row 6, with 4 of 6 elements filled."
    output.must_include "Best point to start solving: (6,6)"
  end

  it "should confirm every allowed blank character" do
    ARGV[0] = "./test_files/every_allowed_character.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "every_allowed_character.txt"
    output.must_include "data is properly formatted"
    output.must_include "Determining box uniqueness is for"
  end

    it "should detect that puzzle is too small for determining box uniqueness" do
    ARGV[0] = "./test_files/too_small_for_box_uniqueness.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Determining box uniqueness is for"
  end

  # NEGATIVE FLOWS

  it "should detect that a given input file doesnt exist" do
    ARGV[0] = "./test_files/jabberwocky.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "jabberwocky.txt"
    output.must_include "ERROR"
    output.must_include "given file doesn't exist"
  end

  it "should detect that puzzle is not a rectangle" do
    ARGV[0] = "./test_files/inconsistent_size.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Rows and/or columns need to be of consistent length"
  end

  it "should detect that puzzle dimensions are mismatched" do
    ARGV[0] = "./test_files/dimensionality_mismatch.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Row length does not match column height"
  end

  it "should detect that puzzle file is empty" do
    ARGV[0] = "./test_files/empty.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "file is empty"
  end

  it "should detect that puzzle file has non-allowed characters" do
    ARGV[0] = "./test_files/non_allowed_character.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "The character (z) is not allowed"
  end

  it "should detect that puzzle file has allowed, but inappropriate, characters" do
    ARGV[0] = "./test_files/nums_too_large.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "The puzzle is 2x2, so the number (3) is not allowed"
  end

  it "should detect that puzzle file has duplicate characters in a row" do
    ARGV[0] = "./test_files/duplicates_in_row.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Row 3 (_33) contains duplicate values"
  end

  it "should detect that puzzle file has duplicate characters in a column" do
    ARGV[0] = "./test_files/duplicates_in_column.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Column 4 (4412) contains duplicate values"
  end

  it "should detect that puzzle file has non-unique boxes" do
    ARGV[0] = "./test_files/non_unique_boxes.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Box 6 (423791846) contains duplicate values"
  end

  it "should detect if the puzzle is just blanks" do
    ARGV[0] = "./test_files/only_blanks.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "puzzle cannot only contain blanks"
  end

end
