require_relative 'solve'
require_relative 'state'

class Loop

	def initialize(matrix)
		@pure_puzzle_matrix = matrix
		@matrix_data = matrix
		@solver = Solve.new(@pure_puzzle_matrix)
	end

	def fill_in_naked_singles

		singled_rows = "nil"
		singled_columns = "null"
		until singled_rows == singled_columns do
			singled_rows = @solver.populate_naked_singles_within_rows
			singled_columns = @solver.populate_naked_singles_within_columns
			singled_boxes = @solver.populate_naked_singles_within_boxes
		end
		@matrix_data = singled_boxes
		return @matrix_data
	end

	def fill_puzzle
		fill_in_naked_singles

		@state = State.new(@matrix_data)
		determinant = Determine.new(@state.board)
		start_point = determinant.find_starting_point

		last_move = nil
		end_time = Time.now + 60

		while Time.now < end_time
			all_possibilities = determinant.determine_all_possible_digits_per_cell
			replacement_row = all_possibilities[start_point[0]]
			replacement_options = replacement_row[start_point[1]]

			if last_move != nil
				iter = replacement_options.index(last_move)
				replacement_options = replacement_options[iter+1, replacement_options.size]
				last_move = nil
			end

			move = choose_move(replacement_options)

			if move == nil
				# Backtrack due to illegal move
				start_point, last_move = @state.pop_state
			else
				@state[start_point[0], start_point[1]] = move
				# Use Determine initializer to break if success
				determinant = Determine.new(@state.board)
				start_point = determinant.find_starting_point
				last_move = nil
			end

			if Time.now >= end_time
				Log.error("Solving the puzzle took longer than 60 seconds. Please reduce puzzle size or diagnose with 'env DEBUG='yes'.")
			end

		end

	end


	private

	def choose_move(values)
		if values.size == 0
			return nil
		else
			return values[0]
		end
	end

end
