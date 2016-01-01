class Analyze
	class << self

		def data_formatting(file_data)
			lines = file_data.split("\n")
			lines.each { |line|
				line.split("").each do |i|
  				puts i
				end
			}
		end

	end
end
