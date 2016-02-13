class Transmute

	def initialize(matrix)
		@pure_puzzle_data = matrix
	end

	def standardize_blanks
		@puzzle_array = []
		@pure_puzzle_data.row_vectors.each { |row|
			row_array = row.to_a
			row_array.map! { |elem| elem =~ /( |_)/ ? "-" : elem }.flatten!
			@puzzle_array.push(row_array)
			@modified_matrix = convert_array_to_matrix(@puzzle_array)
		}
		@modified_matrix
	end

	def convert_array_to_matrix(array_of_arrays)
		matrix_data = Matrix[]
		array_of_arrays.each { |row|
			matrix_data = Matrix.rows(matrix_data.to_a << row)
		}
		return matrix_data
	end

	def convert_matrix_to_boxes(matrix)
		boxes = []
		boxes.push( matrix.minor(0..2,0..2) )		# Box 1
		boxes.push( matrix.minor(0..2,3..5) )		# Box 2
		boxes.push( matrix.minor(0..2,6..8) )		# Box 3
		boxes.push( matrix.minor(3..5,0..2) )		# Box 4
		boxes.push( matrix.minor(3..5,3..5) )		# Box 5
		boxes.push( matrix.minor(3..5,6..8) )		# Box 6
		boxes.push( matrix.minor(6..8,0..2) )		# Box 7
		boxes.push( matrix.minor(6..8,3..5) )		# Box 8
		boxes.push( matrix.minor(6..8,6..8) )		# Box 9
		return boxes
	end

end
