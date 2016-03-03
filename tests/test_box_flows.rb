require 'minitest/autorun'

describe "sudokuru_boxes" do

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
    ENV['DEBUG'] = "yes"
  end

  # def teardown
  #   $time_e = Time.now
  #   puts "#{@test_name} : #{$time_e - $time_s}"
  # end

  # def initialize(name = nil)
  #   @test_name = name
  #   super(name) unless name.nil?
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

  it "should detect that a puzzle and box map combo has no solution" do
    ARGV[0] = "./puzzles/6x6.txt"
    ARGV[1] = "./puzzles/6x6boxb.txt"
    output = capture_stdout { load "sudokuru.rb" }
    output.must_include "ERROR"
    output.must_include "combination has no solution"
  end

end
