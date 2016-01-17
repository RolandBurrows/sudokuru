require_relative "log"
require "matrix"

class Analyze
	attr_reader :matrix_data

	def initialize(file_data)

		begin
			@matrix_data = Matrix[]

			file_data.split("\n").each { |line|
				@matrix_data = Matrix.rows(@matrix_data.to_a << (line.split("")))
			}

		rescue
			Log.error("Rows and/or columns need to be equal length. Please fix and rerun.")
		end

		dimensionality()
	end

	def data_formatting
		@matrix_data.each { |char|
			if !char.match("[1-9]| |-|_")
				Log.error("The character (#{char}) is not allowed. Please fix and rerun.")
			end
		}
		Log.info("Puzzle data is properly formatted.")
	end

	def dimensionality
		if @matrix_data.square?
			Log.info("Puzzle height and length are equivalent.")
		else
			Log.error("Row length does not match column height. Please fix and rerun.")
		end
	end

	def row_uniqueness
		check_digit_uniqueness(@matrix_data.row_vectors, "Row")
	end

	def column_uniqueness
		check_digit_uniqueness(@matrix_data.column_vectors, "Column")
	end

	def box_uniqueness
		edge_length = @matrix_data.row(0).count

		if edge_length == 9
			boxes = []

			boxes.push( @matrix_data.minor(0..2,0..2) )

			boxes.push( @matrix_data.minor(0..2,3..5) )

			boxes.push( @matrix_data.minor(0..2,6..8) )

			boxes.push( @matrix_data.minor(3..5,0..2) )

			boxes.push( @matrix_data.minor(3..5,3..5) )

			boxes.push( @matrix_data.minor(3..5,6..8) )

			boxes.push( @matrix_data.minor(6..8,0..2) )

			boxes.push( @matrix_data.minor(6..8,3..5) )

			boxes.push( @matrix_data.minor(6..8,6..8) )

			check_digit_uniqueness(boxes, "Box")
		else
			Log.info("Determining box uniqueness is for 9x9, not (#{edge_length}x#{edge_length}).")
		end
	end

	def check_digit_uniqueness(array, entity)
		array.each_with_index { |slice, index|
			for i in 1..9
				if (slice.count(i.to_s) > 1)
					Log.error("#{entity} #{index+1} (#{slice.to_a*""}) contains duplicate values. Please fix and rerun.")
				end
			end
		}
		if entity == "Box"
			entity = "boxes"
		else
			entity = (entity.downcase + "s")
		end
		Log.info("Puzzle #{entity} contain no duplicate values.")
	end

end
