Project Title: Sudoku Puzzle
----------

Author: 
----------
>* Name: Stephen Brown 
>* Email: BrownStephenP@gmail.com

License:
----------
This project is for learning uses only and cannot be used for financial gain.

Sudoku:
----------
>This project involved utilizing IB and the model-view-matrix paradigm to create a sudoku puzzle game.
For IB, I used auto-layout using contraints in order to keep the background and puzzle views centered,
and the tiles are placed programmatically. The tiles (buttons) are also placed differently depending on the
size of the device. The game is also playable in landscape or portrait modes. The game also implements 
data persistence, which allows the game to be saved and loaded again once the user starts playing again.

Description:
-----------
>The puzzle itself is a 9x9 grid, with a button layout of 1-9, a pencil toggle button, a delete button and a
menu button. The pencil toggle button allows the user to pencil in 1-9 values into the puzzle. If the toggle
button is still enabled and the delete button is selected, the game will confirm that you want to delete all
penciled values within the highlighted cell. The user can also reselect a value to delete it if it already
exists within the puzzle, both penciled or a set digit. The menu button allows the user to select a new or hard
game, delete all penciled values, delete all entered values, or even have it hide or show conflicting cells by
highlighting them red. Once all the cells are filled and there are no conflicting cells, the user wins and is able
to start a new easy or hard game. 

Build/Run Info:
------------
>1.  Choose a directory to clone repository into
>2.  run "git clone git@github.com:stephenpbrown/Sudoku.git" in terminal
>3.  Open Xcode and navigate to the project using file->open
>4.  Once project loads into Xcode, hit the "play/build" button in the upper left cornerin order to build and run the program.
>(NOTE: If using the encs lab computers, make sure to run /etc/devme, /etc/homeme, and /etc/simme in order to use
the similators within Xcode)
>5.  Project will load after a successful build and will be usable within the Xcode similator
