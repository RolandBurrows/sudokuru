require_relative "log"
require_relative "analyze"
require "matrix"

class Solve

	def initialize(file_data)
		@pure_puzzle_data = Analyze.new(file_data).matrix_data
		spaces = @pure_puzzle_data.each.count(" ")
		dashes = @pure_puzzle_data.each.count("-")
		underscores = @pure_puzzle_data.each.count("_")
		Log.success(file_data) if ((spaces + dashes + underscores) == 0)
	end

	def find_starting_slice
		determine_most_filled_incomplete_row
	end

	def determine_most_filled_incomplete_row
		row_counts = []
		@pure_puzzle_data.row_vectors.each { |row|
			row_digits = 0
			row.each { |char|
				if char.match("[1-9]")
					row_digits += 1
				end
			}
			if row_digits == @pure_puzzle_data.row(0).count
				row_digits = 0
			end
			row_counts.push(row_digits)
		}
		return [row_counts.index(row_counts.max), row_counts.max]
	end

end
