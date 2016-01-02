# Sudokuru!
# Ruby Sudoku puzzle solver at the speed of light.

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| load(f) }

Log.info("Let's solve some Sudoku!")

if ARGV[0] != nil
	input_file = ARGV[0]
else
	Log.info("No file specified. Searching for default input file.")
	input_file = "./puzzles/input.txt"
end

begin
	Log.info("Using provided file: #{input_file}")
	puzzle_file = File.open(input_file, "r")
	puzzle_data = puzzle_file.read
rescue
	Log.error("given file doesn't exist. Halting.")
end

Log.info("File contents:")
Log.tab(puzzle_data)

Analyze.data_formatting(puzzle_data)
Analyze.dimensionality(puzzle_data)

puzzle_file.close
