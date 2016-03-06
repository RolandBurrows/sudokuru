class Transmute

	def initialize(puzzle_matrix=nil, box_map_matrix=nil)
		@pure_puzzle_data = puzzle_matrix
		@pure_boxmap_data = box_map_matrix
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

	def zip_together_puzzle_and_boxmap(puzzle, box_map)
		puzzle_array = []
		puzzle.each_with_index { |cell_contents, row, col|
			puzzle_array.push([cell_contents, row, col])
		}
		boxmap_array = box_map.to_a
		puzzlebox_zipped_array = puzzle_array.zip(boxmap_array.flatten)
		puzzlebox_zipped_array.each { |dataset|
			dataset.flatten!
		}
		# Format: Array of each grid element, as ["cell_contents", rol, col, "box_map_value"]
		return puzzlebox_zipped_array
	end

	def extract_box_values_from_zipped_puzzlebox(puzzlebox)
		box_handler = BoxHandler.new(@pure_puzzle_data, @pure_boxmap_data)
		chars_range = box_handler.allowed_characters
		box_values = []
		chars_range.each { |char|
			box_loader = []
			puzzlebox.each { |dataset|
				if dataset[3] == char
					box_loader.push(dataset[0])
				end
			}
			box_values.push(box_loader)
		}
		return box_values
	end

end
