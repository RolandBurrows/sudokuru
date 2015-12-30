class Log
	class << self

		def info(werds)
			puts "\n"
			puts werds.to_s
		end

		def error(badness)
			puts "\n"
			puts "\033[31mERROR\033[0m - " + badness.to_s
		end

	end
end
