require_relative "log"
require "Matrix"

class Analyze

	def initialize(file_data)
		@rows = file_data.split("\n")

		@matrix_data = Matrix[]

		@rows.each { |line|
			@matrix_data = Matrix.rows(@matrix_data.to_a << (line.split("")))
		}

		@columns = []
		for i in 1..(@matrix_data.count)
			@columns.push(@matrix_data.column(i-1).to_a)
		end
	end

	def data_formatting
		@rows.each { |line|
			line.split("").each { |char|
  			if (char.match("[1-9]| |-|_") != nil)
  				# Pass!
  			else
  				Log.error("Row (#{line}) contains a formatting issue. Please fix and rerun.")
  			end
			}
		}
		Log.info("Puzzle data is properly formatted.")
	end

	def dimensionality
		if @matrix_data.square? == true
			Log.info("Puzzle height and length are equivalent.")
		else
			Log.error("Rows length does not match columns height. Please fix and rerun.")
		end
	end

	def row_uniqueness
		@rows.each { |line|
			for i in 1..9
				if line.count(i.to_s) == 1
					# Pass!
				elsif line.count(i.to_s) == 0
					# Pass!
				else
					Log.error("Row (#{line}) contains duplicate values. Please fix and rerun.")
				end
			end
		}
		
		Log.info("Puzzle rows contain no duplicate values.")
	end

	def column_uniqueness
		@columns.each { |vertical|
			for i in 1..9
				if vertical.count(i.to_s) == 1
					# Pass!
				elsif vertical.count(i.to_s) == 0
					# Pass!
				else
					vertical = vertical*""   # converts the array to a solid string for better readability
					Log.error("Column (#{vertical}) contains duplicate values. Please fix and rerun.")
				end
			end
		}
		
		Log.info("Puzzle column contain no duplicate values.")
	end

end
