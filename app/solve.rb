require_relative "log"
require_relative "analyze"
require_relative "determine"

class Solve

	def initialize(puzzle_data, start_point)
		@analyzer = Analyze.new(puzzle_data)
		@pure_puzzle_data = @analyzer.matrix_data
	end

	def populate_naked_singles
		@pure_puzzle_data.row_vectors.each { |row|
			spaces = row.count(" ")
			dashes = row.count("-")
			underscores = row.count("_")

			digits = (1..(@analyzer.edge_length)).to_a
			string_digits = digits.map(&:to_s)
			row_array = row.to_a

			row_array.delete(" ")
			row_array.delete("-")
			row_array.delete("_")

			missing_digit = (string_digits - row_array)
		}


	end

end
