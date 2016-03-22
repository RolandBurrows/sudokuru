require 'test_helper'

describe "sudokuru_unit_analyze" do

  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    rescue RuntimeError => e
      @error = e.message
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

  it "should detect duplicates in digit uniqueness check" do
    output = capture_stdout {
      load "././app/analyze.rb"
      load "././app/transmute.rb"
      box_map = Matrix.identity(3)
      puzzle = Matrix.zero(3)
      analysis = Analyze.new(puzzle, box_map)
      array = [["1", "1", "1"],["1", "2", "3"]]
      entity = "Column"
      analysis.check_digit_uniqueness(array, entity)
    }
    @error.must_include "Column 1 (111) contains duplicate values. Please fix and rerun."
  end

  it "should raise a deep analysis code error" do
    output = capture_stdout {
      load "././app/analyze.rb"
      load "././app/transmute.rb"
      box_map = Matrix.identity(3)
      puzzle = Matrix.zero(3)
      analysis = Analyze.new(puzzle, box_map)
      array = [["1", "1", "1"],["1", "2", "3"]]
      entity = "Cthulhu"
      analysis.check_digit_uniqueness(array, entity)
    }
    @error.must_equal ("Contact application creator, because they done goofed.")
  end

end
