require_relative "log"
require_relative "analyze"
require "matrix"

class Solve

	def initialize(file_data)
		pure_puzzle_data = Analyze.new(file_data).matrix_data
	end

end
