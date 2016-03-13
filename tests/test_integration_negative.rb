require 'minitest/autorun'

describe "sudokuru_negatives" do

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
    squelch_warnings
    ENV['RUNTIME'] = nil
  end

  def teardown
    # $time_e = Time.now
    # puts "#{@test_name} : #{$time_e - $time_s}"
    ENV['RUNTIME'] = nil
    unsquelch_warnings
  end

  # def initialize(name = nil)
  #   @test_name = name
  #   super(name) unless name.nil?
  # end

  def squelch_warnings
    @warn_level = $VERBOSE
    $VERBOSE = nil
  end

  def unsquelch_warnings
    $VERBOSE = @warn_level
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
    output.must_include "Puzzle/BoxMap file rows and/or columns need to be of consistent length"
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

  it "should detect that the puzzle cant be solved in the time given" do
    ARGV[0] = "./puzzles/9x9.txt"
    ARGV[1] = "./puzzles/9x9boxa.txt"
    output = capture_stdout {
      ENV['RUNTIME'] = "1";
      load "././app/config.rb";
      load "sudokuru.rb";
    }
    output.must_include "Solving the puzzle took longer than (1) seconds."
  end

end
