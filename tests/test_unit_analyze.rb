require 'test_helper'
require 'minitest/autorun'

describe "sudokuru_unit_analyze" do

  it "should detect duplicates in digit uniqueness check" do
    err = ->{
      load "././app/analyze.rb"
      load "././app/transmute.rb"
      box_map = Matrix.identity(3)
      puzzle = Matrix.zero(3)
      analysis = Analyze.new(puzzle, box_map)
      array = [["1", "1", "1"],["1", "2", "3"]]
      entity = "Column"
      analysis.check_digit_uniqueness(array, entity)
    }.must_raise RuntimeError
    err.message.must_equal ("Column 1 (111) contains duplicate values. Please fix and rerun.")
  end

  it "should raise a deep analysis code error" do
    err = ->{
      load "././app/analyze.rb"
      load "././app/transmute.rb"
      box_map = Matrix.identity(3)
      puzzle = Matrix.zero(3)
      analysis = Analyze.new(puzzle, box_map)
      array = [["1", "1", "1"],["1", "2", "3"]]
      entity = "Cthulhu"
      analysis.check_digit_uniqueness(array, entity)
    }.must_raise RuntimeError
    err.message.must_equal ("Contact application creator, because they done goofed.")
  end

end
