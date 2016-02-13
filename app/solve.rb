require_relative "log"
require_relative "transmute"

class Solve

	def initialize(matrix)
		@pure_puzzle_data = matrix
		@edge_length = @pure_puzzle_data.column_count
		@modified_matrix = @pure_puzzle_data
		@string_digits = ("1"..@edge_length.to_s).to_a
		@transmute = Transmute.new(matrix)
	end

	# Note: every method operates on the @modified_matrix variable

	def populate_naked_singles_within_rows
		index_counter = (-1)

		@modified_matrix.row_vectors.each { |row|
			index_counter += 1

			# Grab the given slice and strip out the blanks
			row_array = row.to_a
			row_array.reject! {|item| item == "-" }

			missing_digits = (@string_digits - row_array)

			if (missing_digits.length == 1)
				row_array_again = row.to_a
				# Insert the missing digit back into whichever blank is present
				row_array_again.map! { |elem| elem == ("-") ? missing_digits : elem }.flatten!

				# Replace the old slice with the new one
				@modified_puzzle_data = @modified_matrix.to_a
				@modified_puzzle_data[index_counter] = row_array_again

				@modified_matrix = @transmute.convert_array_to_matrix(@modified_puzzle_data)

				Log.info("Naked single (#{missing_digits.join("")}) detected on row #{index_counter+1}.\nModified puzzle data:")
				Log.tab(@modified_puzzle_data)
			end
		}
		@modified_matrix
	end

	def populate_naked_singles_within_columns
		index_counter = (-1)

		@modified_matrix.column_vectors.each { |column|
			index_counter += 1

			# Grab the given slice and strip out the blanks
			column_array = column.to_a
			column_array.reject! {|item| item == "-" }

			missing_digits = (@string_digits - column_array)

			if (missing_digits.length == 1)
				column_array_again = column.to_a
				# Insert the missing digit back into whichever blank is present
				column_array_again.map! { |elem| elem == ("-") ? missing_digits : elem }.flatten!

				# Replace the old slice with the new one, element by element
				@modified_puzzle_data = @modified_matrix.to_a
				position_index = (-1)
				@modified_puzzle_data.each { |row|
					position_index += 1
					row[index_counter] = column_array_again[position_index]
				}

				@modified_matrix = @transmute.convert_array_to_matrix(@modified_puzzle_data)

				Log.info("Naked single (#{missing_digits.join("")}) detected on column #{index_counter+1}.\nModified puzzle data:")
				Log.tab(@modified_puzzle_data)
			end
		}
		@modified_matrix
	end

	def populate_naked_singles_within_boxes
		if @edge_length == 9

			boxes = @transmute.convert_matrix_to_boxes(@modified_matrix)

			index_counter = (-1)
			boxes.each { |box|
				index_counter += 1

				# Grab the given slice and strip out the blanks
				box_array = box.to_a.flatten!
				box_array.reject! {|item| item == "-" }

				missing_digits = (@string_digits - box_array)

				if (missing_digits.length == 1)
					box_array_again = box.to_a
					# Insert the missing digit back into whichever blank is present
					box_array_again.map! { |elem| elem == ("-") ? missing_digits : elem }.flatten!
					box_array_again = box_array_again.each_slice(3).to_a
					box_mod_matrix = @transmute.convert_array_to_matrix(box_array_again)

					# Replace the old slice with the new one
					boxes[index_counter] = box_mod_matrix

					# Reset boxes to master format
					boxes_array = []
					boxes.each {|elem| boxes_array.push(elem.to_a) }
					boxes_array = boxes_array.flatten(1)
					boxes_sorted = @transmute.convert_boxes_to_matrix(boxes_array)

					@modified_matrix = @transmute.convert_array_to_matrix(boxes_sorted)

					Log.info("Naked single (#{missing_digits.join("")}) detected in box #{index_counter+1}.\nModified puzzle data:")
					Log.tab(@modified_matrix)
				end
			}
		end
		@modified_matrix
	end

end
