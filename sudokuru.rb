# Sudokuru!
# Ruby Sudoku puzzle solver at the speed of light.

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| load(f) }

Log.info("Let's solve some Sudoku!")
$duration_start = nil
$duration_start = Time.now

# Initialize test file from the user or provide a default

if ARGV[0]
	input_file = ARGV[0]
else
	Log.info("No file specified. Searching for default input file.")
	input_file = "./puzzles/input.txt"
end

# Extract file data or warn user of non-existences

begin
	Log.info("Using provided file: #{input_file}")
	puzzle_file = File.open(input_file, "r")
	puzzle_data = puzzle_file.read
	
	if puzzle_data == ""
		Log.error("file is empty.")
	end

	puzzle_file.close

rescue
	Log.error("given file doesn't exist. Halting.")
end

# Display file contents

Log.info("File contents:")
Log.tab(puzzle_data)

# Analyze file contents

analysis = Analyze.new(puzzle_data)

analysis.dimensionality				# Ensure data grid is a square
analysis.data_formatting			# Ensure characters are allowed: (1-9) no larger than puzzle size , space, -, and _
analysis.row_uniqueness
analysis.column_uniqueness
analysis.box_uniqueness

# Solve!
targetting = Determine.new(puzzle_data)
start_point = targetting.find_starting_point
solver = Solve.new(puzzle_data, start_point)
solver.populate_naked_singles
