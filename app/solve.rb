require_relative "log"
require_relative "analyze"
require_relative "determine"

class Solve

	def initialize(puzzle_data, start_point)
		@analyzer = Analyze.new(puzzle_data)
		@pure_puzzle_data = @analyzer.matrix_data
		@modified_puzzle_data = @pure_puzzle_data
		@modified_matrix = nil
	end

	def populate_naked_singles_within_rows
		index_counter = (-1)

		@pure_puzzle_data.row_vectors.each { |row|
			index_counter += 1

			digits = (1..(@analyzer.edge_length)).to_a
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

				@modified_puzzle_data = @modified_puzzle_data.to_a
				@modified_puzzle_data[index_counter] = row_array_again

				@modified_matrix = convert_array_back_to_matrix(@modified_puzzle_data)

				Log.info("Naked single (#{missing_digits.join("")}) detected on row #{index_counter+1}.\nModified puzzle data:")
				tabbed_data = @modified_puzzle_data.collect{|row| row.join("")}
				Log.tab(tabbed_data.join("\n"))
			end
		}

	end

	def convert_array_back_to_matrix(array_of_arrays)
		matrix_data = Matrix[]

		array_of_arrays.each { |row|
			matrix_data = Matrix.rows(matrix_data.to_a << row)
		}
		return matrix_data
	end

end
