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
	input_file = "./puzzles/sample_input.txt"
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

analysis.dimensionality				# Ensure data grid is a square
analysis.data_formatting			# Ensure characters are allowed: (1-9) no larger than puzzle size , space, -, and _
analysis.row_uniqueness
analysis.column_uniqueness
analysis.box_uniqueness

# Solve!
start_point = "nil"
solver = Solve.new(@matrix_data, start_point)

## Fill in any naked singles
singled_rows = "nil"
singled_columns = "null"
until singled_rows == singled_columns do
	singled_rows = solver.populate_naked_singles_within_rows
	singled_columns = solver.populate_naked_singles_within_columns
	filled_naked_singles = Determine.new(singled_columns)
end

filled_naked_singles.determine_all_possible_digits_per_cell

targetting = Determine.new(@matrix_data)
start_point = targetting.find_starting_point
