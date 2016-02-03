require_relative 'determine'
require_relative 'solve'

class Loop

	def initialize(matrix)
		@edge_length = matrix.column_count
		@pure_puzzle_matrix = matrix
		@pure_puzzle_array = matrix.to_a
		@matrix_data = matrix
	end

	def fill_in_naked_singles
		solver = Solve.new(@pure_puzzle_matrix)

		singled_rows = "nil"
		singled_columns = "null"
		until singled_rows == singled_columns do
			singled_rows = solver.populate_naked_singles_within_rows
			singled_columns = solver.populate_naked_singles_within_columns
			singled_boxes = solver.populate_naked_singles_within_boxes
		end
		@matrix_data = singled_boxes
		return @matrix_data
	end

	def attempt_to_fill_puzzle
		fill_in_naked_singles
		determinant = Determine.new(@matrix_data)
		determinant.determine_all_possible_digits_per_cell
		return @matrix_data
	end

end
