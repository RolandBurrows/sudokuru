require "matrix"

class BoxHandler

	def initialize(box_map)
		@matrix_box_map = box_map
		@edge_length = box_map.column_count
	end

	def dimensionality
		if @matrix_box_map.square?
			Log.info("Box Map is a square.")
		else
			Log.error("Box Map row length does not match column height. Please fix and rerun.")
		end
	end

	def data_formatting
		alphabet = ("A".."Z").to_a
		allowed_characters = alphabet[0, @edge_length]
		@matrix_box_map.each { |char|
			if !allowed_characters.include?(char)
				Log.error("The box map character (#{char}) is not allowed. Only #{allowed_characters[0]}-#{allowed_characters[-1]} are allowed. Please fix and rerun.")
			end
		}
		Log.info("Box Map data is properly formatted.")
	end

	def data_uniqueness

	end

end
