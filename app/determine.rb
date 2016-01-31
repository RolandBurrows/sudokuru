require_relative "log"
require_relative "analyze"
require "matrix"

class Determine

	def initialize(matrix)
		@edge_length = matrix.column_count
		@pure_puzzle_matrix = matrix
		@pure_puzzle_array = matrix.to_a
		# Log success if puzzle contains no blanks at all
		spaces = @pure_puzzle_matrix.each.count(" ")
		dashes = @pure_puzzle_matrix.each.count("-")
		underscores = @pure_puzzle_matrix.each.count("_")
		Log.success(@pure_puzzle_matrix) if ((spaces + dashes + underscores) == 0)
		# Log error if puzzle is ONLY blanks
		Log.error("puzzle cannot only contain blanks.") if ((spaces + dashes + underscores) == (@edge_length * @edge_length))
	end

	def find_starting_point
		determine_starting_point(find_complementary_starting_slice(find_prime_starting_slice))
	end

	def find_prime_starting_slice
		best_row = determine_most_filled_incomplete_row(@pure_puzzle_matrix)
		best_column = determine_most_filled_incomplete_column(@pure_puzzle_matrix)

		# If a row and column are of equal goodness, prefer the row
		@best_slice = (best_row[1] >= best_column[1]) ? best_row : best_column
		Log.info("Starting slice is #{@best_slice[3]} #{@best_slice[0]+1}, with #{@best_slice[1]} of #{@edge_length} elements filled.")

		# best_slice composition: [index_of_best_slice, number_filled_spaces, slice_vector, "row" / "column"]
		return @best_slice
	end

	def find_complementary_starting_slice(best_slice)
		find_position_of_slice_in_matrix(best_slice)
		scan_slice_for_blanks(best_slice)

		# Find complementary slice with fewest blanks
		if best_slice[3] == "row"
			best_complementary_slice = @candidate_columns.min_by{|a| a[2]}
		else
			best_complementary_slice = @candidate_rows.min_by{|a| a[2]}
		end

		# candidates_array composition: [index_of_vector, vector_itself, number_of_blanks]
		return best_complementary_slice
	end

	def find_position_of_slice_in_matrix(best_slice)
		@best_slice_index = (-1)
		if best_slice[3] == "row"
			@pure_puzzle_matrix.row_vectors.each { |row|
				@best_slice_index += 1
				if row == best_slice[2]
					@prime_slice = row
					break
				end
			}
		else
			@pure_puzzle_matrix.column_vectors.each { |column|
				@best_slice_index += 1
				if column == best_slice[2]
					@prime_slice = column
					break
				end
			}
		end
	end

	def scan_slice_for_blanks(best_slice)
		@candidate_rows = []
		@candidate_columns = []
		@prime_slice.each_with_index { |value, index|
			if value =~ /( |-|_)/
				if best_slice[3] == "row"
					possible_slice = @pure_puzzle_matrix.column(index)
					candidate = []
					candidate.push(index)
					candidate.push(possible_slice.to_a)
					spaces = possible_slice.each.count(" ")
					dashes = possible_slice.each.count("-")
					underscores = possible_slice.each.count("_")
					candidate.push(spaces + dashes + underscores)
					@candidate_columns.push(candidate)
				else
					possible_slice = @pure_puzzle_matrix.row(index)
					candidate = []
					candidate.push(index)
					candidate.push(possible_slice.to_a)
					spaces = possible_slice.each.count(" ")
					dashes = possible_slice.each.count("-")
					underscores = possible_slice.each.count("_")
					candidate.push(spaces + dashes + underscores)
					@candidate_rows.push(candidate)
				end
			end
		}
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
		Log.info("Best point to start solving: (#{@starting_point[0]+1},#{@starting_point[1]+1})")
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
		@pure_puzzle_matrix.each_with_index { |cell_contents, row, col|
			if ("1".."9").include?(cell_contents)
				possible_digits_array.push("X")
			else
				row_array = @pure_puzzle_matrix.row(row).to_a
				row_array.delete(" ")
				row_array.delete("-")
				row_array.delete("_")

				column_array = @pure_puzzle_matrix.column(col).to_a
				column_array.delete(" ")
				column_array.delete("-")
				column_array.delete("_")

				combo_array = []
				combo_array.push(row_array)
				combo_array.push(column_array)
				combo_array.flatten!
				combo_array.uniq!

				digits = (1..(@edge_length)).to_a
				string_digits = digits.map(&:to_s)
				missing_digits = (string_digits - combo_array)
				possible_digits_array.push(missing_digits)
			end
		}
		return possible_digits_array
	end

end
