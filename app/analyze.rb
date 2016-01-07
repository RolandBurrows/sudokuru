require_relative "log"

class Analyze
	class << self

		def data_formatting(file_data)
			
			lines = file_data.split("\n")

			lines.each { |line|
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

		def dimensionality(file_data)
			lines = file_data.split("\n")
			column_size = lines.length
			lines.each { |line|
				if line.length == column_size
					# Pass!
				else
					Log.error("Row (#{line}) length does not match column height. Please fix and rerun.")
				end
			}

			Log.info("Puzzle height and length are equivalent.")
		end

		def row_uniqueness(file_data)
			lines = file_data.split("\n")
			lines.each { |line|
				for i in 1..9
					if line.count(i.to_s).to_s == "1"
						# Pass!
					elsif line.count(i.to_s).to_s == "0"
						# Pass!
					else
						Log.error("Row (#{line}) contains duplicate values. Please fix and rerun.")
					end
				end
			}
			
			Log.info("Puzzle rows contain no duplicate values.")
		end

		def column_uniqueness(file_data)
			# TODO: Research Matrices
		end

	end
end
