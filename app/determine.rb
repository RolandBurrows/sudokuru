require_relative "log"
require_relative "analyze"
require "matrix"

class Determine

	def initialize(file_data)
		@pure_puzzle_data = Analyze.new(file_data).matrix_data
		@edge_length = @pure_puzzle_data.row(0).count
		spaces = @pure_puzzle_data.each.count(" ")
		dashes = @pure_puzzle_data.each.count("-")
		underscores = @pure_puzzle_data.each.count("_")
		Log.success(file_data) if ((spaces + dashes + underscores) == 0)
	end

	def find_starting_point
		find_complementary_starting_slice(find_prime_starting_slice)
	end

	def find_prime_starting_slice
		best_row = determine_most_filled_incomplete_row(@pure_puzzle_data)
		best_column = determine_most_filled_incomplete_column(@pure_puzzle_data)

		best_slice = (best_row[1] >= best_column[1]) ? best_row : best_column
		Log.info("Starting slice is #{best_slice[3]} #{best_slice[0]+1}, with #{best_slice[1]} of #{@edge_length} elements filled.")

		return best_slice
	end

	def find_complementary_starting_slice(slice)
	end

	def determine_most_filled_incomplete_row(matrix_formatted_data)
		row_counts = []
		matrix_formatted_data.row_vectors.each { |row|
			row_digits = 0
			row.each { |char|
				if char.match("[1-9]")
					row_digits += 1
				end
			}
			if row_digits == @edge_length
				row_digits = 0
			end
			row_counts.push(row_digits)
		}
		number_filled_spaces = row_counts.max
		index_of_best_row = row_counts.index(row_counts.max)
		row_itself = matrix_formatted_data.row_vectors[index_of_best_row]
		return [index_of_best_row, number_filled_spaces, row_itself, "row"]
	end

	def determine_most_filled_incomplete_column(matrix_formatted_data)
		column_counts = []
		matrix_formatted_data.column_vectors.each { |column|
			column_digits = 0
			column.each { |char|
				if char.match("[1-9]")
					column_digits += 1
				end
			}
			if column_digits == matrix_formatted_data.row(0).count
				column_digits = 0
			end
			column_counts.push(column_digits)
		}
		number_filled_spaces = column_counts.max
		index_of_best_column = column_counts.index(column_counts.max)
		column_itself = matrix_formatted_data.column_vectors[index_of_best_column]
		return [index_of_best_column, number_filled_spaces, column_itself, "column"]
	end

end
