require_relative "log"
require_relative "analyze"
require "matrix"

class Solve

	def initialize(file_data)
		@pure_puzzle_data = Analyze.new(file_data).matrix_data
		# @pure_puzzle_data.each { |char|
		# 	if !char.match(" |-|_")
		# 		Log.success(file_data)
		# 	end
		# }
	end

	def find_starting_slice
		determine_most_filled_row
	end

	def determine_most_filled_row
		@pure_puzzle_data.row_vectors.each { |row|
		}
	end

end
