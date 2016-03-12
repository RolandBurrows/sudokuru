class Log
  class << self

    def debug(inner_werkings)
      if Config::DEBUG != nil
        puts "\n"
        puts inner_werkings.to_s
      end
    end

    def error(badness)
      puts "\n"
      puts "\033[31mERROR: \033[0m" + badness.to_s
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
    end

    def tab(move_overs_matrix, debug_on=nil)
      if (debug_on == nil) || ((debug_on != nil) && (Config::DEBUG != nil))
        move_overs_array = move_overs_matrix.to_a
        tabbed_data = move_overs_array.collect{|row| row.join("")}
        puts "\n"
        tabbed_data.each { |row| puts "  #{row}" }
      end
    end

    def double_tab(to_move_boxmap, to_move_puzzle)
      move_overs_box = to_move_boxmap.to_a
      move_overs_puzz = to_move_puzzle.to_a

      tabbed_box = move_overs_box.collect{|row| row.join("")}
      tabbed_puzz = move_overs_puzz.collect{|row| row.join("")}
      puts "\n"
      tabbed_box.zip(tabbed_puzz).each do |box_line, puzzle_line|
        puts "  #{box_line}  #{puzzle_line}"
      end
    end

    def display_raw_data(input_data, entity)
      # Entity == "Puzzle" or "Box Map" for logging
      Log.info("#{entity} file contents:")
      Log.tab(input_data)
    end

  end
end
