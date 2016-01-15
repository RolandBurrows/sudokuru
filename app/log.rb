class Log
	class << self

		def error(badness)
			puts "\n"
			puts "\033[31mERROR\033[0m - " + badness.to_s
			$script_failed = "yes"
			exit
		end

		def info(werds)
			puts "\n"
			puts werds.to_s
		end

		def tab(move_overs)
			puts "\n"
			lines = move_overs.split("\n")
			lines.each { |line| puts "  #{line}" }
		end

	end
end
