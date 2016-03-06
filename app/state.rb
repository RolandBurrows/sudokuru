class State
	attr_reader :board

	def initialize(puzzle_matrix)
		@board = puzzle_matrix
		@move_order = []
	end

	def [](row, col)
		@board[row, col]
	end

	def []=(row, col, value)
		i = [row, col]
		@move_order.push(i)
		# Override private method because Matrices are default immutable
		@board.send(:'[]=', row, col, value)
		Log.debug("Filling cell (#{row+1}, #{col+1}) with (#{value}):")
		Log.tab(@board, "debug_only")
	end

	def pop_state
		k = @move_order.pop
		v = @board[*k]
		@board.send(:'[]=', k[0], k[1], "-")
		[k, v]
	end

end
