require_relative "log"
require_relative "analyze"
require "matrix"

class Solve

	def initialize(file_data)
		@pure_puzzle_data = Analyze.new(file_data).matrix_data
		@edge_length = @pure_puzzle_data.row(0).count
		spaces = @pure_puzzle_data.each.count(" ")
		dashes = @pure_puzzle_data.each.count("-")
		underscores = @pure_puzzle_data.each.count("_")
		Log.success(file_data) if ((spaces + dashes + underscores) == 0)
	end

	def find_starting_slice
		best_row = determine_most_filled_incomplete_row(@pure_puzzle_data).push("row")
		best_column = determine_most_filled_incomplete_column(@pure_puzzle_data).push("column")

		best_slice = (best_row[1] >= best_column[1]) ? best_row : best_column
		Log.info("Starting slice is #{best_slice[2]} #{best_slice[0]+1}, with #{best_slice[1]} of #{@edge_length} elements filled.")

		return best_slice
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
		return [row_counts.index(row_counts.max), row_counts.max]
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
		return [column_counts.index(column_counts.max), column_counts.max]
	end

end
