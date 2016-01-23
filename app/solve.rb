require_relative "log"
require_relative "analyze"

class Solve

	def initialize(puzzle_data, start_point)
		@pure_puzzle_data = Analyze.new(puzzle_data).matrix_data
	end

end
