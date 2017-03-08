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
        // NSLog("init in SudokuPuzzle")
        
        // Initializes puzzle
        self.puzzle = Array(repeating: Array(repeating: cell(), count: 9), count: 9)
    }
    
    
    
    // Set  to plist compatible array (used for data persistence)
    func savedState() -> NSArray {
        let puzzleArray = NSMutableArray(capacity: 9*9)
        
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                let cell = puzzle[r][c]
                let dict : NSDictionary = ["number" : cell.number as Int, "pencils" : cell.pencils as [Bool], "fixed" : cell.fixed as Bool]
                puzzleArray.add(dict)
            }
        }
        return puzzleArray
    }
    
    // Read from plist compatible array (used for data persistence)
    func setState(puzzleArray : NSArray) {
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                puzzle[r][c].number = (puzzleArray[r*9+c] as! NSDictionary).value(forKey: "number") as! Int
                puzzle[r][c].pencils = (puzzleArray[r*9+c] as! NSDictionary).value(forKey: "pencils") as! [Bool]
                puzzle[r][c].fixed = (puzzleArray[r*9+c] as! NSDictionary).value(forKey: "fixed") as! Bool
            }
        }
    }
    
    // Load new game encoded with given string (see Section 4.1)
    func loadPuzzle(puzzleString: String) {
        
        // Parse the string into an array of characters: stackoverflow.com/questions/25921204/convert-swift-string-to-array
        let characters = puzzleString.characters.map { String($0) }
        
        var count = 0
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
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
    func isConflictingEntryAtCell(number: Int, row: Int, column: Int) -> Bool {
        
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
    
    // Check if there are any conflicting cells left within the puzzle
    func anyConflictingCells() -> Bool {
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                if isConflictingEntryAtCell(number: puzzle[r][c].number, row: r, column: c) {
                    return true
                }
            }
        }
        return false
    }
    
    // Clear any conflicting cells
    func clearAllConflictingCells() {
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                if isConflictingEntryAtCell(number: puzzle[r][c].number, row: r, column: c) {
                    puzzle[r][c].number = 0
                }
            }
        }
    }
    
    // Clear all cells that don't have a fixed number in them
    func clearAllCells() {
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                if !puzzle[r][c].fixed {
                    puzzle[r][c].number = 0
                }
            }
        }
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
    
    // Clear all the pencils in every cell
    func clearAllPencilsForEachCell() {
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                clearAllPencils(row: r, column: c)
            }
        }

    }
}
