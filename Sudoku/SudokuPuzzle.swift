//
//  SudokuPuzzle.swift
//  Sudoku
//
//  Created by Stephen Paul Brown on 2/24/17.
//  Copyright © 2017 Stephen Paul Brown. All rights reserved.
//

import Foundation

class SudokuPuzzle {
    
    struct cell {
        var pencils : [Bool] = Array(repeating: false, count: 10)
        var number : Int = 0
        var fixed : Bool = false
    }
    
    var puzzle : [[cell]] = []
    
    // Creates empty puzzle
    init() {
        NSLog("init in SudokuPuzzle")
        
        // Initializes puzzle
        self.puzzle = Array(repeating: Array(repeating: cell(), count: 9), count: 9)
    }
    
    
    
    // Read from plist compatible array (used for data persistence)
    func savedState() -> NSArray {
        return [0]
    }
    
    // Set to plist compatible array (used for data persistence)
    func setState(puzzleString : String) {
        
    }
    
    // Load new game encoded with given string (see Section 4.1)
    func loadPuzzle(puzzleString: String) {
        
        // Parse the string into an array of characters: stackoverflow.com/questions/25921204/convert-swift-string-to-array
        let characters = puzzleString.characters.map { String($0) }
        
        // NSLog("\(characters)")
        
        var count = 0
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                //NSLog("row = \(r), col = \(c), number = \(characters[count])")
                
                if characters[count] != "." {
                    puzzle[r][c].number = Int(characters[count])!
                    puzzle[r][c].fixed = true
                }
                count += 1
            }
        }
    }
    
    // Fetch the number stored in the cell at the specified row and column; zero indicates an empty cell or the cell holds penciled values
    func numberAtRow(row: Int, column: Int) -> Int {
        return puzzle[row][column].number
    }
    
    // Set the number at the specified cell; assumes cell does not contain a fixed number
    func setNumber(number: Int, row: Int, column: Int) {
        puzzle[row][column].number = number
    }
    
    // Determines if cell contains a fixed number
    func numberIsFixedAtRow(row: Int, column: Int) -> Bool {
        return puzzle[row][column].fixed
    }

    // Does the number conflict with any other number in the same row, column, or 3x3 square?
    func isConflictingEntryAtRow(number: Int, row: Int, column: Int) -> Bool {
        
        // Check the column for a conflicting number
        for r in 0 ..< 9 {
            if row != r && puzzle[r][column].number == number {
                return true
            }
        }
        
        // Check the row for a confliction number
        for c in 0 ..< 9 {
            if column != c && puzzle[row][c].number == number {
                return true
            }
        }
        
        let beginColumn = (column - (column % 3))
        let beginRow = (row - (row % 3))
        
        // Check the 3x3 that contains the cell
        for r in beginRow ..< beginRow + 3 {
            for c in beginColumn ..< beginColumn + 3 {
                if (column != c && row != r) && puzzle[r][c].number == number {
                    return true
                }
            }
        }
        
        return false
    }
    
    // Are there any penciled in values at the given cell? (assumes number = 0)
    func anyPencilSetAtCell(row: Int, column: Int) -> Bool {
        
        for i in 0 ..< 10 {
            if puzzle[row][column].pencils[i] == true {
                return true
            }
        }
        
        return false
    }
    
    // Number of penciled in values at cell
    func numberOfPencilsSetAtCell(row: Int, column: Int) -> Int {
        var count = 0
        
        for i in 0 ..< 10 {
            if puzzle[row][column].pencils[i] == true {
                count += 1
            }
        }
        
        return count
    }

    // Is the value n penciled in?
    func isSetPencil(n: Int, row: Int, column: Int) -> Bool {
        return puzzle[row][column].pencils[n]
    }
    
    // Pencil the value n in
    func setPencil(n: Int, row: Int, column: Int) {
        NSLog("n = \(n), row = \(row), column = \(column)")
        puzzle[row][column].pencils[n] = true
    }
    
    // Clear the pencil value n
    func clearPencil(n: Int, row: Int, column: Int) {
        puzzle[row][column].pencils[n] = false
    }
    
    // Clear all penciled in values
    func clearAllPencils(row: Int, column: Int) {
        puzzle[row][column].pencils = Array(repeating: false, count: 10)
    }
}
