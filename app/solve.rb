require_relative "log"
require_relative "analyze"
require_relative "determine"

class Solve
	attr_reader :modified_matrix

	def initialize(matrix)
		@pure_puzzle_data = matrix
		@edge_length = @pure_puzzle_data.column_count
		@modified_matrix = @pure_puzzle_data
	end

	# Note: every method operates on the @modified_matrix variable

	def populate_naked_singles_within_rows
		index_counter = (-1)

		@modified_matrix.row_vectors.each { |row|
			index_counter += 1

			# Set the array of digits that the puzzle could contain
			digits = (1..(@edge_length)).to_a
			string_digits = digits.map(&:to_s)

			# Grab the given slice and strip out the blanks
			row_array = row.to_a
			row_array.delete(" ")
			row_array.delete("-")
			row_array.delete("_")

			missing_digits = (string_digits - row_array)

			if (missing_digits.length == 1)
				row_array_again = row.to_a
				# Insert the missing digit back into whichever blank is present
				row_array_again.map! { |elem| elem == (" ") ? missing_digits : elem }.flatten!
				row_array_again.map! { |elem| elem == ("-") ? missing_digits : elem }.flatten!
				row_array_again.map! { |elem| elem == ("_") ? missing_digits : elem }.flatten!

				# Replace the old slice with the new one
				@modified_puzzle_data = @modified_matrix.to_a
				@modified_puzzle_data[index_counter] = row_array_again

				@modified_matrix = convert_array_back_to_matrix(@modified_puzzle_data)

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

			# Set the array of digits that the puzzle could contain
			digits = (1..(@edge_length)).to_a
			string_digits = digits.map(&:to_s)

			# Grab the given slice and strip out the blanks
			column_array = column.to_a
			column_array.delete(" ")
			column_array.delete("-")
			column_array.delete("_")

			missing_digits = (string_digits - column_array)

			if (missing_digits.length == 1)
				column_array_again = column.to_a
				# Insert the missing digit back into whichever blank is present
				column_array_again.map! { |elem| elem == (" ") ? missing_digits : elem }.flatten!
				column_array_again.map! { |elem| elem == ("-") ? missing_digits : elem }.flatten!
				column_array_again.map! { |elem| elem == ("_") ? missing_digits : elem }.flatten!

				# Replace the old slice with the new one, element by element
				@modified_puzzle_data = @modified_matrix.to_a
				position_index = (-1)
				@modified_puzzle_data.each { |row|
					position_index += 1
					row[index_counter] = column_array_again[position_index]
				}

				@modified_matrix = convert_array_back_to_matrix(@modified_puzzle_data)

				Log.info("Naked single (#{missing_digits.join("")}) detected on column #{index_counter+1}.\nModified puzzle data:")
				Log.tab(@modified_puzzle_data)
			end
		}
		@modified_matrix
	end

	def populate_naked_singles_within_boxes
		if @edge_length == 9

			# Left to right, top to bottom:
			boxes = []
			boxes.push( @modified_matrix.minor(0..2,0..2) )		# Box 1
			boxes.push( @modified_matrix.minor(0..2,3..5) )		# Box 2
			boxes.push( @modified_matrix.minor(0..2,6..8) )		# Box 3
			boxes.push( @modified_matrix.minor(3..5,0..2) )		# Box 4
			boxes.push( @modified_matrix.minor(3..5,3..5) )		# Box 5
			boxes.push( @modified_matrix.minor(3..5,6..8) )		# Box 6
			boxes.push( @modified_matrix.minor(6..8,0..2) )		# Box 7
			boxes.push( @modified_matrix.minor(6..8,3..5) )		# Box 8
			boxes.push( @modified_matrix.minor(6..8,6..8) )		# Box 9

			index_counter = (-1)
			boxes.each { |box|
				index_counter += 1
				# Set the array of digits that the puzzle could contain
				digits = (1..9).to_a
				string_digits = digits.map(&:to_s)

				# Grab the given slice and strip out the blanks
				box_array = box.to_a.flatten!
				box_array.delete(" ")
				box_array.delete("-")
				box_array.delete("_")
				missing_digits = (string_digits - box_array)

				if (missing_digits.length == 1)
					box_array_again = box.to_a
					# Insert the missing digit back into whichever blank is present
					box_array_again.map! { |elem| elem == (" ") ? missing_digits : elem }.flatten!
					box_array_again.map! { |elem| elem == ("-") ? missing_digits : elem }.flatten!
					box_array_again.map! { |elem| elem == ("_") ? missing_digits : elem }.flatten!
					box_array_again = box_array_again.each_slice(3).to_a
					box_mod_matrix = convert_array_back_to_matrix(box_array_again)

					# Replace the old slice with the new one
					boxes[index_counter] = box_mod_matrix
					boxes_array = []
					boxes.each {|elem| boxes_array.push(elem.to_a) }
					boxes_array = boxes_array.flatten(1)

					# Reset boxes to master format
					boxes_sorted = []
					boxes_sorted.push([boxes_array[0], boxes_array[3], boxes_array[6]].flatten!)
					boxes_sorted.push([boxes_array[1], boxes_array[4], boxes_array[7]].flatten!)
					boxes_sorted.push([boxes_array[2], boxes_array[5], boxes_array[8]].flatten!)
					boxes_sorted.push([boxes_array[9], boxes_array[12], boxes_array[15]].flatten!)
					boxes_sorted.push([boxes_array[10], boxes_array[13], boxes_array[16]].flatten!)
					boxes_sorted.push([boxes_array[11], boxes_array[14], boxes_array[17]].flatten!)
					boxes_sorted.push([boxes_array[18], boxes_array[21], boxes_array[24]].flatten!)
					boxes_sorted.push([boxes_array[19], boxes_array[22], boxes_array[25]].flatten!)
					boxes_sorted.push([boxes_array[20], boxes_array[23], boxes_array[26]].flatten!)

					boxes_matrix = convert_array_back_to_matrix(boxes_sorted)
					@modified_puzzle_data = boxes_matrix

					Log.info("Naked single (#{missing_digits.join("")}) detected in box #{index_counter+1}.\nModified puzzle data:")
					Log.tab(@modified_puzzle_data)
				end
			}
		end
		@modified_matrix
	end

	private

	def convert_array_back_to_matrix(array_of_arrays)
		# Matrices are immutable objects == cannot be operated on directly
		matrix_data = Matrix[]

		array_of_arrays.each { |row|
			matrix_data = Matrix.rows(matrix_data.to_a << row)
		}
		return matrix_data
	end

end
