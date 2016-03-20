require 'test_helper'

describe "sudokuru_unit_state" do

  it "should replace non erroneous box values with blanks" do
    load "././app/state.rb"
    puzzle = Matrix[[1,2],[3,4]]
    state = State.new(puzzle)
    state[0,1].must_equal (2)
  end

end
