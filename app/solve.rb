require_relative "log"
require_relative "analyze"
require_relative "determine"

class Solve

	def initialize(puzzle_data, start_point)
		@analyzer = Analyze.new(puzzle_data)
		@pure_puzzle_data = @analyzer.matrix_data
	end

	def populate_naked_singles
		index_counter = (-1)
		@pure_puzzle_data.row_vectors.each { |row|
			index_counter += 1
			spaces = row.count(" ")
			dashes = row.count("-")
			underscores = row.count("_")

			digits = (1..(@analyzer.edge_length)).to_a
			string_digits = digits.map(&:to_s)
			row_array = row.to_a

			row_array.delete(" ")
			row_array.delete("-")
			row_array.delete("_")

			missing_digits = (string_digits - row_array)

			if (missing_digits.length == 1)
				
			end
		}


	end

	def convert_array_back_to_matrix(array_of_arrays)
		matrix_data = Matrix[]

		array_of_arrays.each { |row|
			matrix_data = Matrix.rows(matrix_data.to_a << row)
		}
		return matrix_data
	end

end
