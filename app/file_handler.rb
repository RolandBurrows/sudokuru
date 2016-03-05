class FileHandler

	def initialize(puzzle_file=nil, box_map_file=nil)
		@puzzle_file = puzzle_file
		@box_map_file = box_map_file
	end

	def set_up_puzzle_file
		if @puzzle_file.nil?
			Log.info("No file specified. Searching for default input file.")
			@puzzle_file = "./puzzles/sample_input.txt"
		end
		return @puzzle_file
	end

end
