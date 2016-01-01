require_relative "logging"

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

	end
end
