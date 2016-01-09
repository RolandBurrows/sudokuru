## sudokuru
Ruby Sudoku puzzle solver at the speed of light.

#### The Goal
* To solve a given [Sudoku](https://en.wikipedia.org/wiki/Sudoku) puzzle, particularly of the 'classic' variety (9x9 grid, digits 1-9, with 3x3 sub-grids). Preferred: handle NxN grid (up to 9x9).

#### Application Milestones
Execution:
- [X] A default input.txt file at the app's location should be present.
- [X] User can provide a specific file path as part of execution.

Input (diagnostic checks on validity and formatting):
- [X] Same number of "rows" in txt file as number of "columns" (characters).
- [X] Only digits 1-9 and allowed "blank" characters are present.
- [X] No duplicate digits are already present in puzzle input.

Implementation:
- [ ] Research and then implement algorithm based on real-world player strategies (do not utilize pure mathematical approach).
- [ ] Find starting row/column by calculating which one has the greatest number of pre-filled items.
- [ ] Attempt to use Naked / Hidden singles, pairs, triplets, qauds.

Scaling:
- [ ] Begin with 2x2 grid and scale up.
- [ ] Tests for each level of scale.
