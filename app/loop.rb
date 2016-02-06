require_relative 'determine'
require_relative 'solve'

class Loop

	def initialize(matrix)
		@edge_length = matrix.column_count
		@pure_puzzle_matrix = matrix
		@pure_puzzle_array = matrix.to_a
		@matrix_data = matrix
		@solver = Solve.new(@pure_puzzle_matrix)
		@modified_matrix = Matrix[]
	end

	def fill_in_naked_singles

		singled_rows = "nil"
		singled_columns = "null"
		until singled_rows == singled_columns do
			singled_rows = @solver.populate_naked_singles_within_rows
			singled_columns = @solver.populate_naked_singles_within_columns
			singled_boxes = @solver.populate_naked_singles_within_boxes
		end
		@matrix_data = singled_boxes
		return @matrix_data
	end

	def attempt_to_fill_puzzle
		fill_in_naked_singles

		# Begin loop
		determinant = Determine.new(@matrix_data)
		start_point = determinant.find_starting_point

		# Determine possible entries and insert first guess, repeat
		possible_digits_formatted = determinant.determine_all_possible_digits_per_cell
		# If matrix state has not changed between two loop runs, break
		possible_digits_matrix = @solver.convert_array_back_to_matrix(possible_digits_formatted)
		@matrix_data = possible_digits_matrix

		return @matrix_data
	end


	private

	def fill_matrix_cell_with_value(matrix_data, cell_index, replacement_value)
		data_array = matrix_data.to_a
		data_row = data_array[cell_index[0]]
		existing_value = data_row[cell_index[1]]

		if existing_value !~ /( |-|_)/
			raise "Cannot replace a non-blank value!"
		end

		data_row[cell_index[1]] = replacement_value
		data_array[cell_index[0]] = data_row

		@modified_matrix = @solver.convert_array_back_to_matrix(data_array)
		return @modified_matrix
	end

end
