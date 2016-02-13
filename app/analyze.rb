require_relative "log"
require "matrix"

class Analyze

	def initialize(matrix)
		@edge_length = matrix.column_count
		@matrix_data = matrix
	end

	def dimensionality
		if @matrix_data.square?
			Log.info("Puzzle is a square.")
		else
			Log.error("Row length does not match column height. Please fix and rerun.")
		end
	end

	def data_formatting
		@matrix_data.each { |char|
			# Only 1-9, " ", "-", "_" are allowed
			if !char.match("[1-9]| |-|_")
				Log.error("The character (#{char}) is not allowed. Please fix and rerun.")
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

	def box_uniqueness(log=nil)
		# The goal is for all numbers 1-9 to appear only once in each row, column, and 3x3 box

		if @edge_length == 9
			boxes = []

			# Left to right, top to bottom:
			boxes.push( @matrix_data.minor(0..2,0..2) )		# Box 1
			boxes.push( @matrix_data.minor(0..2,3..5) )		# Box 2
			boxes.push( @matrix_data.minor(0..2,6..8) )		# Box 3
			boxes.push( @matrix_data.minor(3..5,0..2) )		# Box 4
			boxes.push( @matrix_data.minor(3..5,3..5) )		# Box 5
			boxes.push( @matrix_data.minor(3..5,6..8) )		# Box 6
			boxes.push( @matrix_data.minor(6..8,0..2) )		# Box 7
			boxes.push( @matrix_data.minor(6..8,3..5) )		# Box 8
			boxes.push( @matrix_data.minor(6..8,6..8) )		# Box 9
			check_digit_uniqueness(boxes, "Box")
			Log.info("Puzzle boxes contain no duplicate values.") if log
		else
			Log.info("Determining box uniqueness is for 9x9, not (#{@edge_length}x#{@edge_length}).") if log
		end
	end

	def check_digit_uniqueness(array, entity)
		# Entity = 'row', 'column', 'box' for logging
		array.each_with_index { |slice, index|
			for i in 1..9
				# Check if digits 1-9 appear more than (once or less)
				if (slice.count(i.to_s) > 1)
					Log.error("#{entity} #{index+1} (#{slice.to_a*""}) contains duplicate values. Please fix and rerun.")
				end
			end
		}
	end

end
