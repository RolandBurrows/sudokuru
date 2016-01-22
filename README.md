## sudokuru
Ruby Sudoku puzzle solver at the speed of light.

[![Build Status](https://semaphoreci.com/api/v1/projects/f143a17b-2c6c-45c1-8698-5e79c8e736b7/663467/shields_badge.svg)](https://semaphoreci.com/rolandburrows/sudokuru)  [![Code Climate](https://codeclimate.com/github/RolandBurrows/sudokuru/badges/gpa.svg)](https://codeclimate.com/github/RolandBurrows/sudokuru)

#### The Goal
* To solve a given [Sudoku](https://en.wikipedia.org/wiki/Sudoku) puzzle, particularly of the 'classic' variety (9x9 grid, digits 1-9, with 3x3 sub-grids). Preferred: handle NxN grid (up to 9x9).

#### Execution
Within the sudokuru folder:
```
$ ruby sudokuru.rb <path to file>
```
In the absence of a file path provided, sudokuru will default to:
```
$ ruby sudokuru.rb ./puzzles/input.txt
```

#### Input Formatting
Input puzzles should be common file types (.txt, .rb, etc.), one row per line, formatted:
```
1-3-        1_3_        1 3         1 3-
-14-        _14_         14         -14_   
24-3   or   24_3   or   24 3   or   24-3
--2-        __2_          2         _-2 
dashes    underscores   spaces      mixed
```
With digits 1-9 and the blank characters "-", "_", and spaces allowed only.

Errors will be returned if the data is not properly formatted, with directions to fix:
```
ERROR - Row 7 (-324-9--3) contains duplicate values. Please fix and rerun.
```

Otherwise, the solution will be returned:
```
SOLUTION:
  534678912
  672195348
  198342567
  859761423
  426853791
  713924856
  961537284
  287419635
  345286179
```

#### Application Milestones
Execution:
- [X] A default input.txt file at the app's location should be present.
- [X] User can provide a specific file path as part of execution.

Input (diagnostic checks on validity and formatting):
- [X] Same number of "rows" in txt file as number of "columns" (characters).
- [X] Only digits 1-9 and allowed "blank" characters are present, none larger than the puzzle size.
- [X] No duplicate digits are already present in puzzle rows/columns.
- [X] No duplicate digits in 9x9 puzzle sub-boxes.
- [X] Tests for each input check.

Implementation:
- [X] Find starting row/column by calculating which one has the greatest number of pre-filled items.
- [ ] Research and then implement algorithm based on real-world player strategies (do not utilize pure mathematical approach).
- [ ] Attempt to use Naked / Hidden singles, pairs, triplets, qauds.

Scaling:
- [ ] Begin with 2x2 sample puzzles and scale up to 9x9.

Stretch Goals:
- [ ] Ability to use photo of sudoku puzzle, and OCR loads the data for solving.
- [ ] Smartphone app
