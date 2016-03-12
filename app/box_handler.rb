require "matrix"

class BoxHandler
  attr_reader :allowed_characters

  def initialize(puzzle_matrix, box_map_matrix)
    @puzzle_matrix = puzzle_matrix
    @box_map_matrix = box_map_matrix
    @box_edge_length = box_map_matrix.column_count
    alphabet = ("A".."Z").to_a
    @allowed_characters = alphabet[0, @box_edge_length]
  end

  def dimensionality(puzzle_matrix)
    if @box_map_matrix.square?
      Log.info("Box Map is square.")
    else
      raise "Box Map row length does not match column height. Please fix and rerun."
    end
    @puzzle_edge_len = puzzle_matrix.column_count
    if @puzzle_edge_len == @box_edge_length
      Log.info("Puzzle and Box Map are equally sized.")
    else
      raise "Puzzle is (#{@puzzle_edge_len}x#{@puzzle_edge_len}), but Box Map is (#{@box_edge_length}x#{@box_edge_length}). Please fix and rerun."
    end
  end

  def data_formatting
    @box_map_matrix.each { |char|
      if !@allowed_characters.include?(char)
        raise "The Box Map character (#{char}) is not allowed. Only #{allowed_characters[0]}-#{allowed_characters[-1]} are allowed. Please fix and rerun."
      end
    }
    Log.info("Box Map data is properly formatted.")
  end

  def data_uniqueness
    given_characters = []
    @box_map_matrix.each { |char|
      given_characters.push(char)
    }
    character_counts = []
    @allowed_characters.each { |char|
      character_counts.push(given_characters.count(char))
    }
    if character_counts.uniq.length != 1
      Log.info("Box Map items and counts:")
      i = 0
      character_counts.each { |count|
        puts "Character: (#{@allowed_characters[i]}), count: (#{count})"
        i += 1
      }
      raise "The Box Map boxes are not of equal area."
    end
    Log.info("Box Map boxes are of equal area.")
  end

  def box_uniqueness(log=nil)
    transmute = Transmute.new(@puzzle_matrix, @box_map_matrix)
    puzzlebox = transmute.zip_together_puzzle_and_boxmap(@puzzle_matrix, @box_map_matrix)
    boxes = transmute.extract_box_values_from_zipped_puzzlebox(puzzlebox)
    analyze = Analyze.new(@puzzle_matrix, @box_map_matrix)
    analyze.check_digit_uniqueness(boxes, "Box")
    Log.info("Puzzle boxes contain no duplicate values.") if log
  end

  def replace_non_erroneous_box_values_with_blanks(box_map, value)
    box_details = box_map.to_a
    box_details.each { |slice|
      slice.map! { |elem| elem != value ? "-" : elem }.flatten!
    }
    transmute = Transmute.new()
    box_details = transmute.convert_array_to_matrix(box_details)
    return box_details
  end

end
