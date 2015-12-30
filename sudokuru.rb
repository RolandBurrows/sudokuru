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
	file = File.open(input_file, "r")
rescue
	Log.error("given file doesn't exist. Halting.")
	exit
end

data = file.read
file.close
