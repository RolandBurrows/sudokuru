# Sudokuru!
# Ruby Sudoku puzzle solver at the speed of light.

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| require(f) }

Log.info("Let's solve some Sudoku!")
$duration_start = Time.now
$box_map_used = false

# Initialize test file from the user or provide a default

if ARGV[0]
	input_file = ARGV[0]
else
	Log.info("No file specified. Searching for default input file.")
	input_file = "./puzzles/sample_input.txt"
end

if ARGV[1]
	box_map_file = ARGV[1]
else
	Log.info("No box map file specified for the given puzzle. Proceeding without.")
end

# Extract file data or warn user of non-existences

begin
	Log.info("Using provided puzzle file: #{input_file}")
	puzzle_data = File.read(input_file)
	if puzzle_data == ""
		Log.error("puzzle file is empty.")
	end
rescue
	Log.error("given puzzle file doesn't exist. Halting.")
end

begin
	if box_map_file
		$box_map_used = true
		Log.info("Using provided box map file: #{box_map_file}")
		box_map_data = File.read(box_map_file)
		if box_map_file == ""
			Log.error("box map file is empty.")
		end
	end
rescue
	Log.error("given box map file doesn't exist. Halting.")
end

# Convert puzzle file and box map contexts to matrices

converter = Transmute.new()

begin
	@matrix_puzzle_data = converter.convert_file_data_to_matrix(puzzle_data)
	Log.info("Puzzle file contents:")
	Log.tab(@matrix_puzzle_data)
rescue
	Log.error("Puzzle file rows and/or columns need to be of consistent length. Please fix and rerun.")
end

begin
	if box_map_file
		@matrix_box_data = converter.convert_file_data_to_matrix(box_map_data)
		Log.info("Box Map file contents:")
		Log.tab(@matrix_box_data)
	end
rescue
	Log.error("Box map rows and/or columns need to be of consistent length. Please fix and rerun.")
end

# Analyze puzzle file contents

analysis = Analyze.new(@matrix_puzzle_data, @matrix_box_data)
analysis.dimensionality
analysis.data_formatting
analysis.row_uniqueness("log it!")
analysis.column_uniqueness("log it!")

# Analyze box map file contents

if @matrix_box_data
	boxysis = BoxHandler.new(@matrix_box_data)
	boxysis.dimensionality(@matrix_puzzle_data)
	boxysis.data_formatting
	boxysis.data_uniqueness
	analysis.box_uniqueness("log it!")
end

# Format puzzle

transmute = Transmute.new(@matrix_puzzle_data)
@puzzle_matrix = transmute.standardize_blanks

# Solve!

looper = Loop.new(@puzzle_matrix, @matrix_box_data)
looper.fill_puzzle
