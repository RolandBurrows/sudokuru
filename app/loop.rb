class Loop

  def initialize(puzzle_matrix, box_map_matrix)
    @puzzle_matrix = puzzle_matrix
    @box_map_matrix = box_map_matrix
    @matrix_data = puzzle_matrix
  end

  def fill_puzzle
    @state = State.new(@matrix_data)
    determinant = Determine.new(@state.board, @box_map_matrix)
    # Return immediately if puzzle is already complete
    return @state.board if determinant.victory != nil

    start_point = determinant.find_starting_point
    last_move = nil
    end_time = Time.now + Config::RUNTIME

    while Time.now < end_time
      all_possibilities = determinant.determine_all_possible_digits_per_cell
      replacement_row = all_possibilities[start_point[0]]
      replacement_options = replacement_row[start_point[1]]

      if last_move != nil
        iter = replacement_options.index(last_move)
        replacement_options = replacement_options[iter+1, replacement_options.size]
        last_move = nil
      end

      move = choose_move(replacement_options)

      if move == nil
        # Backtrack due to illegal move
        start_point, last_move = @state.pop_state
      else
        @state[start_point[0], start_point[1]] = move
        # Use Determine initializer to break if success
        determinant = Determine.new(@state.board, @box_map_matrix)
        return @state.board if determinant.victory != nil

        start_point = determinant.find_starting_point
        last_move = nil
      end
    end
    raise "Solving the puzzle took longer than (#{Config::RUNTIME}) seconds. Please reduce puzzle size or diagnose with (env DEBUG='yes')."
  end


  private

  def choose_move(values)
    if values.size == 0
      return nil
    else
      return values[0]
    end
  end

end
