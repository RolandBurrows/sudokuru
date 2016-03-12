# Sudokuru!
# Ruby Sudoku puzzle solver at the speed of light.

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| require(f) }

Log.info("Let's solve some Sudoku!")
$duration_start = Time.now

# ARGV[0] == puzzle file, ARGV[1] == box map file
begin
  completed_puzzle = Sudoku.new(ARGV[0], ARGV[1]).solve_it
  Log.success(completed_puzzle)
rescue RuntimeError => e
  Log.error(e.message)
end
