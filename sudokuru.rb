# Sudokuru!
# Ruby Sudoku puzzle solver at the speed of light.

puts ""
puts "Let's solve some Sudoku!"

if ARGV[0] != nil
	input_file = ARGV[0]
else
	puts "No file specified. Searching for default input file."
	input_file = "./puzzles/input.txt"
end

begin
	puts "Using provided file: #{input_file}"
	file = File.open(input_file, "r")
rescue
	exit
end

data = file.read
file.close
