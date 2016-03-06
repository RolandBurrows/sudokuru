# Sudokuru!
# Ruby Sudoku puzzle solver at the speed of light.

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/bin/**/*.rb"].each { |f| require(f) }

Log.info("Let's solve some Sudoku!")
$duration_start = Time.now

# ARGV[0] == puzzle file, ARGV[1] == box map file
Sudokuru.new(ARGV[0], ARGV[1])
