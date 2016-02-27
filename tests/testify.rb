require 'minitest/autorun'

describe "sudokuru" do

  # Specs are not actually order dependent
  # This is just here to fix flakey minitest file loading
  i_suck_and_my_tests_are_order_dependent!()

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

  # def setup
  #   $time_s = Time.now
  # end

  # def teardown
  #   $time_e = Time.now
  #   puts "#{@test_name} : #{$time_e - $time_s}"
  # end

  # def initialize(name = nil)
  #   @test_name = name
  #   super(name) unless name.nil?
  # end

  # LOGGING

  it "should print debug logging when the DEBUG env var is activated" do
    ENV["DEBUG"] = "yes"
    output = capture_stdout { require "././app/log"; Log.debug("Doot Doot") }
    output.must_include "Doot Doot"
  end

  # SAMPLE SOLVING FLOWS

  it "should process the default input file when no specific file is given" do
    ARGV[0] = nil
    ARGV[1] = nil
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "No file specified"
		output.must_include "input.txt"
		output.must_include "Puzzle file contents:"
		output.must_include "is a square"
		output.must_include "data is properly formatted"
		output.must_include "rows contain no duplicate values"
		output.must_include "columns contain no duplicate values"
		output.must_include "SUCCESS"
		output.must_include "Solution found in:"
  end

  it "should solve a blank puzzle" do
    ARGV[0] = "./test_files/only_blanks.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  it "should solve a 2x2 puzzle" do
    ARGV[0] = "./puzzles/2x2.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  it "should solve a 3x3 puzzle" do
    ARGV[0] = "./puzzles/3x3.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  it "should solve a 4x4 puzzle" do
    ARGV[0] = "./puzzles/4x4.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  it "should solve a 5x5 puzzle" do
    ARGV[0] = "./puzzles/5x5.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  it "should solve a 6x6 puzzle" do
    ARGV[0] = "./puzzles/6x6.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  it "should solve a 7x7 puzzle" do
    ARGV[0] = "./puzzles/7x7.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  it "should solve a 8x8 puzzle" do
    ARGV[0] = "./puzzles/8x8.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  it "should solve a 9x9 puzzle" do
    ARGV[0] = "./puzzles/9x9.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

  # POSITIVE FLOWS

  it "should determine the starting slice to be a row" do
    ENV["DEBUG"] = "yes"
    ARGV[0] = "./test_files/starting_row.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Starting slice is row 3, with 2 of 4 elements filled."
  end

  it "should determine the starting slice to be a column" do
    ENV["DEBUG"] = "yes"
    ARGV[0] = "./test_files/starting_column.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Starting slice is column 4, with 2 of 4 elements filled."
  end

  it "should determine the starting point" do
    ENV["DEBUG"] = "yes"
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
  end

  # NEGATIVE FLOWS

  it "should detect that a given input file doesnt exist" do
    ARGV[0] = "./test_files/jabberwocky.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "jabberwocky.txt"
    output.must_include "ERROR"
    output.must_include "given puzzle file doesn't exist"
  end

  it "should detect that puzzle is not a rectangle" do
    ARGV[0] = "./test_files/inconsistent_size.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Puzzle file rows and/or columns need to be of consistent length"
  end

  it "should detect that puzzle dimensions are mismatched" do
    ARGV[0] = "./test_files/dimensionality_mismatch.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Puzzle row length does not match column height"
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
    output.must_include "Puzzle character (z) is not allowed"
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

  # it "should detect that puzzle file has non-unique boxes" do
  # end

  # BOX FLOWS

  it "should not process the default box file when no file is specified" do
    ARGV[0] = nil
    ARGV[1] = nil
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "No box map file specified"
    output.must_include "input.txt"
    output.must_include "Using provided puzzle file"
    output.wont_include "Using provided box map file"
    output.wont_include "sample_input_boxmap.txt"
    output.wont_include "Box Map file contents"
    output.wont_include "Box Map is square"
    output.wont_include "Box Map data is properly formatted"
    output.must_include "SUCCESS"
  end

  it "should process the box file specified" do
    ARGV[0] = "./puzzles/sample_input.txt"
    ARGV[1] = "./puzzles/sample_input_boxmap.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "Using provided puzzle file"
    output.must_include "input.txt"
    output.must_include "Using provided box map file"
    output.must_include "input_boxmap.txt"
    output.must_include "Box Map file contents"
    output.must_include "Box Map is square"
    output.must_include "Box Map data is properly formatted"
    output.must_include "SUCCESS"
  end

  it "should detect an imbalanced box map" do
    ARGV[0] = "./puzzles/9x9.txt"
    ARGV[1] = "./test_files/imbalanced_box_map.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Box Map boxes are not of equal area"
  end

  it "should detect that the puzzle and box map are unequal in size" do
    ARGV[0] = "./test_files/puzzleboxmap_mismatch.txt"
    ARGV[1] = "./test_files/boxmappuzzle_mismatch.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "Puzzle is (8x8), but Box Map is (6x6)"
  end

  it "should solve a puzzle with two possible box maps" do
    # Box Map A
    ARGV[0] = "./puzzles/6x6blank.txt"
    ARGV[1] = "./puzzles/6x6boxa.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
    # Box Map B
    ARGV[0] = "./puzzles/6x6blank.txt"
    ARGV[1] = "./puzzles/6x6boxb.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "SUCCESS"
  end

end
