require 'test_helper'

describe "sudokuru_unit_box_handler" do

  it "should replace non erroneous box values with blanks" do
    load "././app/box_handler.rb"
    load "././app/transmute.rb"
    box_map = Matrix.identity(3)
    puzzle = Matrix.zero(3)
    box_handler = BoxHandler.new(puzzle, box_map)
    value = 1
    output = box_handler.replace_non_erroneous_box_values_with_blanks(box_map, value)
    output.must_equal (Matrix[[1, "-", "-"], ["-", 1, "-"], ["-", "-", 1]])
  end

end
