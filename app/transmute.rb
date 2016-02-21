class Transmute

	def initialize(matrix=nil)
		@pure_puzzle_data = matrix
	end

	def convert_file_data_to_matrix(file_data)
		matrix_data = Matrix[]
		file_data.split("\n").each { |line|
			matrix_data = Matrix.rows(matrix_data.to_a << (line.split("")))
		}
		return matrix_data
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

	def convert_boxes_to_matrix(boxes_array)
		boxes_sorted = []
		boxes_sorted.push([boxes_array[0], boxes_array[3], boxes_array[6]].flatten!)
		boxes_sorted.push([boxes_array[1], boxes_array[4], boxes_array[7]].flatten!)
		boxes_sorted.push([boxes_array[2], boxes_array[5], boxes_array[8]].flatten!)
		boxes_sorted.push([boxes_array[9], boxes_array[12], boxes_array[15]].flatten!)
		boxes_sorted.push([boxes_array[10], boxes_array[13], boxes_array[16]].flatten!)
		boxes_sorted.push([boxes_array[11], boxes_array[14], boxes_array[17]].flatten!)
		boxes_sorted.push([boxes_array[18], boxes_array[21], boxes_array[24]].flatten!)
		boxes_sorted.push([boxes_array[19], boxes_array[22], boxes_array[25]].flatten!)
		boxes_sorted.push([boxes_array[20], boxes_array[23], boxes_array[26]].flatten!)
		return boxes_sorted
	end

end
