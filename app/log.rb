class Log
	class << self

		def error(badness)
			puts "\n"
			puts "\033[31mERROR\033[0m - " + badness.to_s
			exit(1)
		end

		def info(werds)
			puts "\n"
			puts werds.to_s
		end

		def success(goodness)
			puts "\n"
			puts "\033[32mSOLUTION:\033[0m"
			Log.tab(goodness)
			exit(0)
		end

		def tab(move_overs)
			puts "\n"
			lines = move_overs.split("\n")
			lines.each { |line| puts "  #{line}" }
		end

	end
end
