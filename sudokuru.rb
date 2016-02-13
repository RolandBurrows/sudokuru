# Sudokuru!
# Ruby Sudoku puzzle solver at the speed of light.

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| load(f) }

Log.info("Let's solve some Sudoku!")
$duration_start = Time.now

# Initialize test file from the user or provide a default

if ARGV[0]
	input_file = ARGV[0]
else
	Log.info("No file specified. Searching for default input file.")
	input_file = "./puzzles/sample_input.txt"
end

# Extract file data or warn user of non-existences

begin
	Log.info("Using provided file: #{input_file}")
	puzzle_data = File.read(input_file)
	if puzzle_data == ""
		Log.error("file is empty.")
	end
rescue
	Log.error("given file doesn't exist. Halting.")
end

# Convert file contexts to matrix

begin
	@matrix_data = Matrix[]
	puzzle_data.split("\n").each { |line|
		# Convert raw file lines into a matrix object of individual characters
		@matrix_data = Matrix.rows(@matrix_data.to_a << (line.split("")))
	}
	# Display file contents
	Log.info("File contents:")
	Log.tab(@matrix_data)
rescue
	Log.error("Rows and/or columns need to be of consistent length. Please fix and rerun.")
end

# Analyze file contents

analysis = Analyze.new(@matrix_data)
analysis.dimensionality
analysis.data_formatting
analysis.row_uniqueness("log it!")
analysis.column_uniqueness("log it!")
analysis.box_uniqueness("log it!")

# Format it

transmute = Transmute.new(@matrix_data)
@trans_matrix = transmute.standardize_blanks

# Solve!

looper = Loop.new(@trans_matrix)
looper.fill_puzzle
