# Sudokuru!
# Ruby Sudoku puzzle solver at the speed of light.

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| load(f) }

Log.info("Let's solve some Sudoku!")

# Initialize test file from the user or provide a default

if ARGV[0] != nil
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

rescue
	Log.error("given file doesn't exist. Halting.")
end

# Display file contents

Log.info("File contents:")
Log.tab(puzzle_data)

# Analyze file contents

analysis = Analyze.new(puzzle_data)

analysis.data_formatting
analysis.dimensionality
analysis.row_uniqueness

# analysis.column_uniqueness TODO: Implement.

# Cleanup

puzzle_file.close
