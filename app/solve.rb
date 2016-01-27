require_relative "log"
require_relative "analyze"
require_relative "determine"

class Solve
	attr_reader :modified_matrix

	def initialize(matrix, start_point)
		@pure_puzzle_data = matrix
		@edge_length = @pure_puzzle_data.column_count
		@modified_matrix = @pure_puzzle_data
	end

	def populate_naked_singles_within_rows
		index_counter = (-1)

		@modified_matrix.row_vectors.each { |row|
			index_counter += 1

			digits = (1..(@edge_length)).to_a
			string_digits = digits.map(&:to_s)
			row_array = row.to_a

			row_array.delete(" ")
			row_array.delete("-")
			row_array.delete("_")

			missing_digits = (string_digits - row_array)

			if (missing_digits.length == 1)
				row_array_again = row.to_a
				row_array_again.map! { |elem| elem == (" ") ? missing_digits : elem }.flatten!
				row_array_again.map! { |elem| elem == ("-") ? missing_digits : elem }.flatten!
				row_array_again.map! { |elem| elem == ("_") ? missing_digits : elem }.flatten!

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

			digits = (1..(@edge_length)).to_a
			string_digits = digits.map(&:to_s)
			column_array = column.to_a

			column_array.delete(" ")
			column_array.delete("-")
			column_array.delete("_")

			missing_digits = (string_digits - column_array)

			if (missing_digits.length == 1)
				column_array_again = column.to_a
				column_array_again.map! { |elem| elem == (" ") ? missing_digits : elem }.flatten!
				column_array_again.map! { |elem| elem == ("-") ? missing_digits : elem }.flatten!
				column_array_again.map! { |elem| elem == ("_") ? missing_digits : elem }.flatten!

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

	def convert_array_back_to_matrix(array_of_arrays)
		matrix_data = Matrix[]

		array_of_arrays.each { |row|
			matrix_data = Matrix.rows(matrix_data.to_a << row)
		}
		return matrix_data
	end

end
