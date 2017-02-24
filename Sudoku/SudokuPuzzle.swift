//
//  SudokuPuzzle.swift
//  Sudoku
//
//  Created by Stephen Paul Brown on 2/24/17.
//  Copyright © 2017 Stephen Paul Brown. All rights reserved.
//

import Foundation

class SudokuPuzzle {
    
    // Creates empty puzzle
    init() {
        NSLog("init in SudokuPuzzle")
    }
    
    // Write to plist compatible array (used for data persistence)
    func savedState() -> NSArray {
        return [0]
    }
    
    // Read from plist compatible array (used for data persistence)
    func setState(puzzleString : String) {
        
    }
    
    // Load new game encoded with given string (see Section 4.1
    func loadPuzzle(puzzleString: String) {
        
    }
    
    // Fetch the number stored in the cell at the specified row and column; zero indicates an empty cell or the cell holds penciled values
    func numberAtRow(row: Int, column: Int) -> Int {
        return 0
    }
    
    // Set the number at the specified cell; assumes cell does not contain a fixed number
    func setNumber(number: Int, row: Int, column: Int) {
        
    }
    
    // Determines if cell contains a fixed number
    func numberIsFixedAtRow(row: Int, column: Int) -> Bool {
        return false
    }

    // Does the number conflict with any other number in the same row, column, or 3x3 square?
    func isConflictingEntryAtRow(row: Int, column: Int) -> Bool {
        return false
    }
    
    // Are there any penciled in values at the given cell? (assumes number = 0)
    func anyPencilSetAtRow(row: Int, column: Int) -> Bool {
        return false
    }
    
    // Number of penciled in values at cell
    func numberOfPencilsSetAtRow(row: Int, column: Int) -> Int {
        return 0
    }

    // Is the value n penciled in?
    func isSetPencil(n: Int, row: Int, column: Int) -> Bool {
        return false
    }
    
    // Pencil the value n in
    func setPencil(n: Int, row: Int, column: Int) {
        
    }
    
    // Clear the pencil value n
    func clearPencil(n: Int, row: Int, column: Int) {
        
    }
    
    // Clear all penciled in values
    func clearAllPencils(row: Int, column: Int) {
        
    }
}
