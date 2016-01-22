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
			$duration_end = Time.now

			puts "\n"
			puts "\033[32mSUCCESS!\033[0m Solution found in: #{$duration_end - $duration_start} seconds."
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
