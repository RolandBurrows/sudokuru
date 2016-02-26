require "matrix"

class BoxHandler
	attr_reader :allowed_characters

	def initialize(box_map)
		@matrix_box_map = box_map
		@edge_length = box_map.column_count
		alphabet = ("A".."Z").to_a
		@allowed_characters = alphabet[0, @edge_length]
	end

	def dimensionality(puzzle_matrix)
		if @matrix_box_map.square?
			Log.info("Box Map is square.")
		else
			Log.error("Box Map row length does not match column height. Please fix and rerun.")
		end
		@puzzle_edge_len = puzzle_matrix.column_count
		if @puzzle_edge_len == @edge_length
			Log.info("Puzzle and Box Map are equally sized.")
		else
			Log.error("Puzzle is (#{@puzzle_edge_len}x#{@puzzle_edge_len}), but Box Map is (#{@edge_length}x#{@edge_length}). Please fix and rerun.")
		end
	end

	def data_formatting
		@matrix_box_map.each { |char|
			if !@allowed_characters.include?(char)
				Log.error("The Box Map character (#{char}) is not allowed. Only #{allowed_characters[0]}-#{allowed_characters[-1]} are allowed. Please fix and rerun.")
			end
		}
		Log.info("Box Map data is properly formatted.")
	end

	def data_uniqueness
		given_characters = []
		@matrix_box_map.each { |char|
			given_characters.push(char)
		}
		character_counts = []
		@allowed_characters.each { |char|
			character_counts.push(given_characters.count(char))
		}
		if character_counts.uniq.length != 1
			Log.info("Box Map items and counts:")
			i = 0
			character_counts.each { |count|
				puts "Character: (#{@allowed_characters[i]}), count: (#{count})"
				i += 1
			}
			Log.error("The Box Map boxes are not of equal area.")
		end
		Log.info("Box Map boxes are of equal area.")
	end

end
