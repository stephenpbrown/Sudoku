//
//  ViewController.swift
//  SudokuLayout
//
//  Created by Stephen Paul Brown on 2/7/17.
//  Copyright © 2017 Stephen Paul Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pencilEnabled : Bool = false  // controller property
    var gameWon : Bool = false // Check whether the game has been won or not
    
    @IBOutlet weak var puzzleView: PuzzleView!
    @IBOutlet weak var buttonsView: ButtonsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numberSelected(_ sender: UIButton) {
        let tag = sender.tag
        
        NSLog("number selected: \(tag)")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        
        let row = puzzleView.selected.row
        let column = puzzleView.selected.column
        
        //NSLog("row = \(row), column = \(column)")
        
        if row >= 0 && column >= 0  && !gameWon {
            
            if pencilEnabled && !(puzzle?.isSetPencil(n: tag, row: row, column: column))! && puzzle?.numberAtRow(row: row, column: column) == 0 {
                puzzle?.setPencil(n: tag, row: row, column: column)
            }
            else if !pencilEnabled && (puzzle?.numberAtRow(row: row, column: column))! == 0 {
                puzzle?.setNumber(number: tag, row: row, column: column)
                // Maybe clear pencils here?
            }
            else if pencilEnabled && (puzzle?.isSetPencil(n: tag, row: row, column: column))! {
                puzzle?.clearPencil(n: tag, row: row, column: column)
            }
            else if puzzle?.numberAtRow(row: row, column: column) == tag {
                puzzle?.setNumber(number: 0, row: row, column: column)
            }
            
            var emptyCells = 0
            // Check to see if the game has been solved
            for r in 0 ..< 9 {
                for c in 0 ..< 9 {
                    if puzzle?.puzzle[r][c].number == 0 {
                        emptyCells += 1
                    }
                }
            }
            
            NSLog("emptyCells = \(emptyCells)")
            
            // If no empty cells left, check for solved game by making sure there are no conflicts
            if emptyCells == 0 {
                NSLog("Should be zero: \(emptyCells)")
                if !(puzzle?.anyConflictingCells())! {
                    NSLog("Puzzle solved!")
                
                    gameWon = true
                    let alertController = UIAlertController(
                        title: "Great job! You solved the puzzle!",
                        message: "",
                        preferredStyle: .alert
                    )
                    // Option for a new easy puzzle
                    alertController.addAction(UIAlertAction(
                        title: "New Easy Game",
                        style: .default,
                        handler: { (UIAlertAction) -> Void in
                            self.newGame(newGameType: "simple")
                    }))
                    // Option for a new hard puzzle
                    alertController.addAction(UIAlertAction(
                        title: "New Hard Game",
                        style: .default,
                        handler: { (UIAlertAction) -> Void in
                            self.newGame(newGameType: "hard")
                    }))
                    alertController.addAction(UIAlertAction(
                        title: "Close",
                        style: .cancel,
                        handler: nil)
                    )
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            puzzleView.setNeedsDisplay()
        }
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        // let tag = sender.tag
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        
        let row = puzzleView.selected.row
        let column = puzzleView.selected.column

        if row >= 0 && column >= 0 && !gameWon {
        
            if (puzzle?.numberAtRow(row: row, column: column))! > 0 {
                puzzle?.setNumber(number: 0, row: row, column: column)
                puzzleView.setNeedsDisplay()
            }
            else if pencilEnabled && (puzzle?.anyPencilSetAtCell(row: row, column: column))! {
                let alertController = UIAlertController(
                    title: "Deleting all penciled values in cell!",
                    message: "Are you sure?",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil)
                )
                alertController.addAction(UIAlertAction(
                    title: "Yes",
                    style: .default,
                    handler: { (UIAlertAction) -> Void in
                        puzzle?.clearAllPencils(row: row, column: column)
                        self.puzzleView.setNeedsDisplay()
                    })
                )
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func newGame(newGameType: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.sudoku = SudokuPuzzle()
        var puzzleStr = ""
        
        if newGameType == "simple" {
            puzzleStr = appDelegate.randomPuzzle(puzzles: appDelegate.simplePuzzles)
        }
        else if newGameType == "hard" {
            puzzleStr = appDelegate.randomPuzzle(puzzles: appDelegate.hardPuzzles)
        }
        
        appDelegate.sudoku?.loadPuzzle(puzzleString: puzzleStr)
        self.puzzleView.selected = (-1, -1)
        self.gameWon = false
        self.puzzleView.setNeedsDisplay()
    }
    
    @IBAction func pencilButton(_ sender: UIButton) {
        NSLog("pencil")
        
        pencilEnabled = !pencilEnabled   // toggle
        sender.isSelected = pencilEnabled
    }
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        NSLog("menu")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        
        let alertController = UIAlertController(
            title: "Main Menu",
            message: nil,
            preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        // Option for a new easy puzzle
        alertController.addAction(UIAlertAction(
            title: "New Easy Game",
            style: .default,
            handler: { (UIAlertAction) -> Void in
                let secondaryAlertController = UIAlertController(
                    title: "Start a new easy game?",
                    message: "",
                    preferredStyle: .alert
                )
                secondaryAlertController.addAction(UIKit.UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil
                ))
                secondaryAlertController.addAction(UIKit.UIAlertAction(
                    title: "Yes",
                    style: .default,
                    handler: { (UIAlertAction) -> Void in
                        self.newGame(newGameType: "simple")
                }))
                self.present(secondaryAlertController, animated: true, completion: nil)
        }))
        
        // Option for a new hard puzzle
        alertController.addAction(UIAlertAction(
            title: "New Hard Game",
            style: .default,
            handler: { (UIAlertAction) -> Void in
                let secondaryAlertController = UIAlertController(
                    title: "Start a new hard game?",
                    message: "",
                    preferredStyle: .alert
                )
                secondaryAlertController.addAction(UIKit.UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil
                ))
                secondaryAlertController.addAction(UIKit.UIAlertAction(
                    title: "Yes",
                    style: .default,
                    handler: { (UIAlertAction) -> Void in
                        self.newGame(newGameType: "hard")
                }))
                self.present(secondaryAlertController, animated: true, completion: nil)
        }))
        
        if !gameWon {
            // Toggles between showing and hiding conflicting cells
            if !self.puzzleView.showConflictingCells {
                alertController.addAction(UIAlertAction(
                    title: "Highlight Conflicting Cells",
                    style: .default,
                    handler: { (UIAlertAction) -> Void in
                        self.puzzleView.showConflictingCells = !self.puzzleView.showConflictingCells
                        self.puzzleView.setNeedsDisplay()
                }))
            }
            else {
                alertController.addAction(UIAlertAction(
                    title: "Stop Highlighting Conflicting Cells",
                    style: .default,
                    handler: { (UIAlertAction) -> Void in
                        self.puzzleView.showConflictingCells = !self.puzzleView.showConflictingCells
                        self.puzzleView.setNeedsDisplay()
                }))
            }
            
            // Clear all conflicting cells
            alertController.addAction(UIAlertAction(
                title: "Clear Conflicting Cells",
                style: .default,
                handler: { (UIAlertAction) -> Void in
                    let secondaryAlertController = UIAlertController(
                        title: "Clearing all conflicting cells!",
                        message: "Are you sure?",
                        preferredStyle: .alert
                    )
                    secondaryAlertController.addAction(UIKit.UIAlertAction(
                        title: "Cancel",
                        style: .cancel,
                        handler: nil
                    ))
                    secondaryAlertController.addAction(UIKit.UIAlertAction(
                        title: "Yes",
                        style: .default,
                        handler: { (UIAlertAction) -> Void in
                            puzzle?.clearAllConflictingCells()
                            self.puzzleView.setNeedsDisplay()
                    }))
                    self.present(secondaryAlertController, animated: true, completion: nil)
            }))
            
            // Clears all entered values at all cells
            alertController.addAction(UIAlertAction(
                title: "Clear All Entered Values",
                style: .default,
                handler: { (UIAlertAction) -> Void in
                    let secondaryAlertController = UIAlertController(
                        title: "Clearing all entered values!",
                        message: "Are you sure?",
                        preferredStyle: .alert
                    )
                    secondaryAlertController.addAction(UIKit.UIAlertAction(
                        title: "Cancel",
                        style: .cancel,
                        handler: nil
                    ))
                    secondaryAlertController.addAction(UIKit.UIAlertAction(
                        title: "Yes",
                        style: .default,
                        handler: { (UIAlertAction) -> Void in
                            puzzle?.clearAllCells()
                            //puzzle?.clearAllPencilsForEachCell()
                            self.puzzleView.setNeedsDisplay()
                    }))
                    self.present(secondaryAlertController, animated: true, completion: nil)
            }))
            
            
            // Clears all penciled values for all cells
            alertController.addAction(UIAlertAction(
                title: "Clear All Penciled Values",
                style: .default,
                handler: { (UIAlertAction) -> Void in
                    let secondaryAlertController = UIAlertController(
                        title: "Clearing all penciled values!",
                        message: "Are you sure?",
                        preferredStyle: .alert
                    )
                    secondaryAlertController.addAction(UIKit.UIAlertAction(
                        title: "Cancel",
                        style: .cancel,
                        handler: nil
                    ))
                    secondaryAlertController.addAction(UIKit.UIAlertAction(
                        title: "Yes",
                        style: .default,
                        handler: { (UIAlertAction) -> Void in
                            puzzle?.clearAllPencilsForEachCell()
                            self.puzzleView.setNeedsDisplay()
                    }))
                    self.present(secondaryAlertController, animated: true, completion: nil)
            }))
        }
         // ... add other actions ...
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let popoverPresenter = alertController.popoverPresentationController
            let menuButtonTag = 12
            let menuButton = buttonsView.viewWithTag(menuButtonTag)
            popoverPresenter?.sourceView = menuButton
            popoverPresenter?.sourceRect = (menuButton?.bounds)!
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
}

