require "matrix"

class Analyze

  def initialize(puzzle_matrix, box_map_matrix)
    @puzzle_matrix = puzzle_matrix
    @box_map_matrix = box_map_matrix
    @edge_length = puzzle_matrix.column_count
    @transmute = Transmute.new(puzzle_matrix)
  end

  def dimensionality
    if @puzzle_matrix.square?
      Log.info("Puzzle is a square.")
    else
      Log.error("Puzzle row length does not match column height. Please fix and rerun.")
    end
  end

  def data_formatting
    @puzzle_matrix.each { |char|
      # Only 1-9, " ", "-", "_" are allowed
      if !char.match("[1-9]| |-|_")
        Log.error("Puzzle character (#{char}) is not allowed. Please fix and rerun.")
      end
      # Ensure there is no digit larger than the puzzle size (a 6x6 grid cannot use digits 7-9)
      if char.to_i > @edge_length.to_i
        Log.error("The puzzle is #{@edge_length}x#{@edge_length}, so the number (#{char}) is not allowed. Please fix and rerun.")
      end
    }
    Log.info("Puzzle data is properly formatted.")
  end

  def row_uniqueness(log=nil)
    check_digit_uniqueness(@puzzle_matrix.row_vectors, "Row")
    Log.info("Puzzle rows contain no duplicate values.") if log
  end

  def column_uniqueness(log=nil)
    check_digit_uniqueness(@puzzle_matrix.column_vectors, "Column")
    Log.info("Puzzle columns contain no duplicate values.") if log
  end

  def check_digit_uniqueness(array, entity)
    # Entity = 'Row', 'Column', 'Box' for logging
    array.each_with_index { |slice, index|
      for i in 1..9
        if (slice.count(i.to_s) > 1)
          if ["Row","Column"].include? entity
            Log.error("#{entity} #{index+1} (#{slice.to_a*""}) contains duplicate values. Please fix and rerun.")
          elsif entity == "Box"
            value = (index+65).chr
            Log.info("Error details:")
            box_handler = BoxHandler.new(@puzzle_matrix, @box_map_matrix)
            box_details = box_handler.replace_non_erroneous_box_values_with_blanks(@box_map_matrix, value)
            puzzle_details = replace_box_values_with_puzzle_values(box_details, value, slice)
            Log.double_tab(box_details, puzzle_details)
            Log.error("#{entity} #{value} (#{slice.to_a*""}) contains duplicate values. Please fix and rerun.")
          else
            Log.error("Contact application creator, because they done goofed.")
          end
        end
      end
    }
  end

  private

  def replace_box_values_with_puzzle_values(box_matrix, value, puzzle_slice)
    puzzle_details = box_matrix.clone
    puzzle_slice.each { |kajigger|
      box_index = puzzle_details.find_index(value)
      # Override private method because Matrices are default immutable
      puzzle_details.send(:'[]=', box_index[0], box_index[1], kajigger)
    }
    return puzzle_details
  end

end
