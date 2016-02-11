class Transmute

	def initialize(matrix)
		@pure_puzzle_data = matrix
	end

	def standardize_blanks
		@puzzle_array = []
		@pure_puzzle_data.row_vectors.each { |row|
			row_array = row.to_a
			row_array.map! { |elem| elem == (" ") ? "-" : elem }.flatten!
			row_array.map! { |elem| elem == ("_") ? "-" : elem }.flatten!
			@puzzle_array.push(row_array)
			@modified_matrix = convert_array_back_to_matrix(@puzzle_array)
		}
		@modified_matrix
	end

	def convert_array_back_to_matrix(array_of_arrays)
		matrix_data = Matrix[]
		array_of_arrays.each { |row|
			matrix_data = Matrix.rows(matrix_data.to_a << row)
		}
		return matrix_data
	end

end
