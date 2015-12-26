## sudokuru
Ruby Sudoku puzzle solver at the speed of light.

#### The Goal
* To solve a given [Sudoku](https://en.wikipedia.org/wiki/Sudoku) puzzle, particularly of the 'classic' variety (9x9 grid, digits 1-9, with 3x3 sub-grids).

#### Application Milestones
Execution:
- [ ] A default input.txt file at the app's location should be present.
- [ ] Provide a specific file path as part of execution.

Input (diagnostic checks on validity and formatting):
- [ ] Same number of "rows" in txt file as number of "columns" (characters).
- [ ] Only digits 1-9 and allowed "blank" characters are present.
- [ ] No duplicate digits are already present in puzzle input.

Implementation:
- [ ] Research and then implement algorithm based on real-world player strategies (do not utilize pure mathematical approach).
- [ ] Find starting row/column by calculating which one has the greatest number of pre-filled items.
- [ ] Attempt to use Naked / Hidden singles, pairs, triplets, qauds.
