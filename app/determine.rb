class Determine

	def initialize(puzzle_matrix, box_map_matrix)
		@puzzle_matrix = puzzle_matrix
		@box_map_matrix = box_map_matrix
		@edge_length = puzzle_matrix.column_count
		Log.success(puzzle_matrix) if (count_the_blanks(puzzle_matrix) == 0)
	end

	def find_starting_point
		determine_starting_point(
			find_complementary_starting_slice(
				find_prime_starting_slice))
	end

	def find_prime_starting_slice
		best_row = determine_most_filled_incomplete_row(@puzzle_matrix)
		best_column = determine_most_filled_incomplete_column(@puzzle_matrix)

		# If a row and column are of equal goodness, prefer the row
		@best_slice = (best_row[1] >= best_column[1]) ? best_row : best_column
		Log.debug("Starting slice is #{@best_slice[3]} #{@best_slice[0]+1}, with #{@best_slice[1]} of #{@edge_length} elements filled.")

		# best_slice composition: [index_of_best_slice, number_filled_spaces, slice_vector, "row" / "column"]
		return @best_slice
	end

	def find_complementary_starting_slice(best_slice)
		@best_slice_index = best_slice[0]
		@prime_slice = best_slice[2]

		candidate_slices = scan_slice_for_blanks(best_slice)

		# Find complementary slice with fewest blanks
		best_complementary_slice = candidate_slices.min_by{|a| a[2]}

		# candidates_array composition: [index_of_vector, vector_itself, number_of_blanks]
		return best_complementary_slice
	end

	def scan_slice_for_blanks(best_slice)
		candidate_slices = []
		@prime_slice.each_with_index { |value, index|
			candidate = []
			if value == "-"
				if best_slice[3] == "row"
					possible_slice = @puzzle_matrix.column(index)
				else
					possible_slice = @puzzle_matrix.row(index)
				end
				candidate.push(index)
				candidate.push(possible_slice.to_a)
				candidate.push(count_the_blanks(possible_slice))
				candidate_slices.push(candidate)
			end
		}
		return candidate_slices
	end

	def determine_starting_point(best_complementary_slice)
		@starting_point = []
		if @best_slice[3] == "row"
			@starting_point.push(@best_slice[0])
			@starting_point.push(best_complementary_slice[0])
		else
			@starting_point.push(best_complementary_slice[0])
			@starting_point.push(@best_slice[0])
		end
		Log.debug("Best point to start solving: (#{@starting_point[0]+1},#{@starting_point[1]+1})")
		return @starting_point
	end

	def determine_most_filled_incomplete_row(matrix_formatted_data)
		row_counts = []
		# In each row, count the number of filled items (1-9 already present)
		matrix_formatted_data.row_vectors.each { |row|
			row_digits = 0
			row.each { |char|
				if char.match("[1-9]")
					row_digits += 1
				end
			}
			# Ignore row if completely filled
			if row_digits == @edge_length
				row_digits = 0
			end
			row_counts.push(row_digits)
		}
		number_filled_spaces = row_counts.max
		# Pick the best row based on the highest count (first one found)
		index_of_best_row = row_counts.index(row_counts.max)
		row_itself = matrix_formatted_data.row_vectors[index_of_best_row]
		# Return the index, the count of it, the row object, and a logging word
		return [index_of_best_row, number_filled_spaces, row_itself, "row"]
	end

	def determine_most_filled_incomplete_column(matrix_formatted_data)
		column_counts = []
		# In each column, count the number of filled items (1-9 already present)
		matrix_formatted_data.column_vectors.each { |column|
			column_digits = 0
			column.each { |char|
				if char.match("[1-9]")
					column_digits += 1
				end
			}
			# Ignore column if completely filled
			if column_digits == matrix_formatted_data.row(0).count
				column_digits = 0
			end
			column_counts.push(column_digits)
		}
		number_filled_spaces = column_counts.max
		# Pick the best column based on the highest count (first one found)
		index_of_best_column = column_counts.index(column_counts.max)
		column_itself = matrix_formatted_data.column_vectors[index_of_best_column]
		# Return the index, the count of it, the column object, and a logging word
		return [index_of_best_column, number_filled_spaces, column_itself, "column"]
	end

	def determine_all_possible_digits_per_cell
		possible_digits_array = []
		@puzzle_matrix.each_with_index { |cell_contents, row, col|
			if ("1".."9").include?(cell_contents)
				possible_digits_array.push("X")
			else
				combo_array = []

				row_array = @puzzle_matrix.row(row).to_a
				combo_array.push(row_array)

				column_array = @puzzle_matrix.column(col).to_a
				combo_array.push(column_array)

				if @box_map_matrix
					box_array = return_box_values_from_matrix_and_index(@puzzle_matrix, [row,col])
					combo_array.push(box_array)
				end

				combo_array.flatten!
				combo_array.uniq!

				digits = (1..(@edge_length)).to_a
				string_digits = digits.map(&:to_s)
				missing_digits = (string_digits - combo_array)
				possible_digits_array.push(missing_digits)
			end
		}
		possible_digits_formatted = []
		possible_digits_array.each_slice(@edge_length) { |chunk|
			possible_digits_formatted.push(chunk)
		}
		return possible_digits_formatted
	end

	def return_box_values_from_matrix_and_index(matrix, index)
	  transmute = Transmute.new(matrix, @box_map_matrix)
	  puzzlebox = transmute.zip_together_puzzle_and_boxmap(matrix, @box_map_matrix)
	  index_data = puzzlebox.detect { |dataset| dataset[1] == index[0] and dataset[2] == index[1]}
	  boxchar = index_data[3]
	  box_values = []
	  puzzlebox.each { |dataslice|
	  	if dataslice[3] == boxchar
	  		box_values.push(dataslice[0])
	  	end
	  }
	  return box_values
	end


	private

	def count_the_blanks(vector)
		vector.each.count("-")
	end

end
