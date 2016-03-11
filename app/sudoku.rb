class Sudoku

  def initialize(puzzle_file, boxmap_file)
    file_handler = FileHandler.new(puzzle_file, boxmap_file)
    @puzzle_data = file_handler.extract_puzzle_data_from_file
    @box_map_data = file_handler.extract_boxmap_data_from_file
    @matrix_puzzle_data = nil
    @matrix_box_data = nil

    convert_files_to_matrices

    Log.display_raw_data(@matrix_puzzle_data, "Puzzle")
    Log.display_raw_data(@matrix_box_data, "Box Map") if @matrix_box_data

    analyze_puzzle_file_contents

    analyze_box_file_contents

    # Format puzzle
    transmute = Transmute.new(@matrix_puzzle_data)
    @puzzle_matrix = transmute.standardize_blanks

    solve_it
  end

  def convert_files_to_matrices
    converter = Transmute.new()
    begin
      @matrix_puzzle_data = converter.convert_file_data_to_matrix(@puzzle_data)
      @matrix_box_data = converter.convert_file_data_to_matrix(@box_map_data) if @box_map_data
    rescue
      Log.error("Puzzle/BoxMap file rows and/or columns need to be of consistent length. Please fix and rerun.")
    end
  end

  def analyze_puzzle_file_contents
  	analysis = Analyze.new(@matrix_puzzle_data, @matrix_box_data)
    analysis.dimensionality
    analysis.data_formatting
    analysis.row_uniqueness("log it!")
    analysis.column_uniqueness("log it!")
  end

  def analyze_box_file_contents
  	if @matrix_box_data
      boxysis = BoxHandler.new(@matrix_puzzle_data, @matrix_box_data)
      boxysis.dimensionality(@matrix_puzzle_data)
      boxysis.data_formatting
      boxysis.data_uniqueness
      boxysis.box_uniqueness("log it!")
    end
  end

  def solve_it
  	looper = Loop.new(@puzzle_matrix, @matrix_box_data)
    begin
      looper.fill_puzzle
    rescue
      if @box_map_data
        Log.error("Puzzle + box map combination has no solution.")
      else
        Log.error("Puzzle has no solution.")
      end
    end
  end

end
