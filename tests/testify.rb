require 'minitest/autorun'

describe "sudokuru_main" do

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

  def setup
    # $time_s = Time.now
    ARGV[0] = nil
    ARGV[1] = nil
  end

  # def teardown
  #   $time_e = Time.now
  #   puts "#{@test_name} : #{$time_e - $time_s}"
  # end

  # def initialize(name = nil)
  #   @test_name = name
  #   super(name) unless name.nil?
  # end

  def activate_debug_logging
    @warn_level = $VERBOSE
    $VERBOSE = nil
    ENV['DEBUG'] = nil
  end

  def deactivate_debug_logging
    $VERBOSE = @warn_level
    ENV['DEBUG'] = nil
  end

  # LOGGING

  it "should print debug logging when the DEBUG env var is activated" do
    activate_debug_logging
    output = capture_stdout {
      ENV['DEBUG'] = "yes";
      load "././app/config.rb";
      load "././app/log.rb";
      Log.debug("Doot Doot");
    }
    deactivate_debug_logging
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
    activate_debug_logging
    ARGV[0] = "./test_files/starting_row.txt"
    output = capture_stdout { load "sudokuru.rb" }
    deactivate_debug_logging
    output.must_include "Starting slice is row 3, with 2 of 4 elements filled."
  end

  it "should determine the starting slice to be a column" do
    activate_debug_logging
    ARGV[0] = "./test_files/starting_column.txt"
    output = capture_stdout { load "sudokuru.rb" }
    deactivate_debug_logging
    output.must_include "Starting slice is column 4, with 2 of 4 elements filled."
  end

  it "should determine the starting point" do
    activate_debug_logging
    ARGV[0] = "./test_files/starting_index.txt"
    output = capture_stdout { load "sudokuru.rb" }
    deactivate_debug_logging
    output.must_include "Starting slice is row 6, with 4 of 6 elements filled."
    output.must_include "Best point to start solving: (6,6)"
  end

  it "should confirm every allowed blank character" do
    ARGV[0] = "./test_files/every_allowed_character.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "every_allowed_character.txt"
    output.must_include "data is properly formatted"
  end

end
