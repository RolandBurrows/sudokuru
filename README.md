## sudokuru
Ruby Sudoku puzzle solver at the speed of light.

[![Build Status](https://semaphoreci.com/api/v1/projects/f143a17b-2c6c-45c1-8698-5e79c8e736b7/663467/shields_badge.svg)](https://semaphoreci.com/rolandburrows/sudokuru)  [![Code Climate](https://codeclimate.com/github/RolandBurrows/sudokuru/badges/gpa.svg)](https://codeclimate.com/github/RolandBurrows/sudokuru)

#### The Goal
* To solve a given [Sudoku](https://en.wikipedia.org/wiki/Sudoku) puzzle, particularly of the 'classic' variety (9x9 grid, digits 1-9, with 3x3 sub-grids). Preferred: handle NxN grid (up to 9x9).

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
- [ ] Find starting row/column by calculating which one has the greatest number of pre-filled items.
- [ ] Research and then implement algorithm based on real-world player strategies (do not utilize pure mathematical approach).
- [ ] Attempt to use Naked / Hidden singles, pairs, triplets, qauds.

Scaling:
- [ ] Begin with 2x2 grid and scale up to 9x9.

Stretch Goals:
- [ ] Ability to use photo of sudoku puzzle, and OCR loads the data for solving.
- [ ] Smartphone app