class FileHandler

  def initialize(puzzle_file=nil, box_map_file=nil)
    @puzzle_file = puzzle_file
    @box_map_file = box_map_file
  end

  def extract_puzzle_data_from_file
    if @puzzle_file.nil?
      Log.info("No file specified. Searching for default input file.")
      @puzzle_file = "./puzzles/sample_input.txt"
    end
    begin
      Log.info("Using puzzle file: #{@puzzle_file}")
      puzzle_data = File.read(@puzzle_file)
    rescue
      raise "given puzzle file doesn't exist. Halting."
    end
    if puzzle_data == ""
      raise "puzzle file is empty."
    end
    return puzzle_data
  end

  def extract_boxmap_data_from_file
    if @box_map_file.nil?
      Log.info("No box map file specified for the given puzzle. Proceeding without.")
    end
    if @box_map_file
      begin
        Log.info("Using provided box map file: #{@box_map_file}")
        box_map_data = File.read(@box_map_file)
      rescue
        raise "given box map file doesn't exist. Halting."
      end
      if box_map_data == ""
        raise "box map file is empty."
      end
    end
    return box_map_data
  end

end
