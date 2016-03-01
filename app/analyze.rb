require "matrix"

class Analyze

	def initialize(matrix, box_map)
		@edge_length = matrix.column_count
		@matrix_data = matrix
		@boxmap_data = box_map
		@transmute = Transmute.new(matrix)
	end

	def dimensionality
		if @matrix_data.square?
			Log.info("Puzzle is a square.")
		else
			Log.error("Puzzle row length does not match column height. Please fix and rerun.")
		end
	end

	def data_formatting
		@matrix_data.each { |char|
			# Only 1-9, " ", "-", "_" are allowed
			if !char.match("[1-9]| |-|_")
				Log.error("Puzzle character (#{char}) is not allowed. Please fix and rerun.")
			end
			# Ensure there is no digit larger than the puzzle size (a 6x6 grid cannot use digits 7-9)
			if char.to_i > @edge_length.to_i
				Log.error("The puzzle is #{@edge_length}x#{@edge_length}, so the number (#{char}) is not allowed. Please fix and rerun.")
			end
		}
		Log.info("Puzzle data is properly formatted.")
	end

	def row_uniqueness(log=nil)
		check_digit_uniqueness(@matrix_data.row_vectors, "Row")
		Log.info("Puzzle rows contain no duplicate values.") if log
	end

	def column_uniqueness(log=nil)
		check_digit_uniqueness(@matrix_data.column_vectors, "Column")
		Log.info("Puzzle columns contain no duplicate values.") if log
	end

	def check_digit_uniqueness(array, entity)
		# Entity = 'row', 'column', 'box' for logging
		array.each_with_index { |slice, index|
			for i in 1..9
				if (slice.count(i.to_s) > 1)
					Log.error("#{entity} #{index+1} (#{slice.to_a*""}) contains duplicate values. Please fix and rerun.")
				end
			end
		}
	end

end
