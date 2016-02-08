require_relative "log"

class State
	attr_reader :board

	def initialize(matrix)
		@board = matrix
		@move_order = []
	end

	def [](r, c)
		@board[r, c]
	end

	def []=(r, c, value)
		i = [r, c]
		@move_order.push(i)
		# Override private method because Matrices are default immutable
		@board.send(:'[]=', r, c, value)
		Log.debug("Filling cell (#{r+1}, #{c+1}) with (#{value}):")
		Log.tab(@board, "debug_only")
	end

	def pop_state
		k = @move_order.pop
		v = @board[*k]
		# TODO: Convert matrix input at source to use only "-" blank char
		@board.send(:'[]=', k[0], k[1], "-")
		[k, v]
	end

end
