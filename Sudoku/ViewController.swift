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
    
    @IBOutlet weak var puzzleView: PuzzleView!
    
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
        
        NSLog("row = \(row), column = \(column)")
        
        if row >= 0 && column >= 0 {
        
            if pencilEnabled && !(puzzle?.isSetPencil(n: tag, row: row, column: column))! && puzzle?.numberAtRow(row: row, column: column) == 0 {
                puzzle?.setPencil(n: tag, row: row, column: column)
            }
            else if !pencilEnabled && !(puzzle?.anyPencilSetAtCell(row: row, column: column))! && (puzzle?.numberAtRow(row: row, column: column))! == 0 {
                puzzle?.setNumber(number: tag, row: row, column: column)
            }
            else if pencilEnabled && (puzzle?.isSetPencil(n: tag, row: row, column: column))! {
                puzzle?.clearPencil(n: tag, row: row, column: column)
            }
            else if puzzle?.numberAtRow(row: row, column: column) == tag {
                puzzle?.setNumber(number: 0, row: row, column: column)
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

        if row >= 0 && column >= 0 {
        
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
                        appDelegate.sudoku = SudokuPuzzle()
                        let puzzleStr = appDelegate.randomPuzzle(puzzles: appDelegate.simplePuzzles)
                        appDelegate.sudoku?.loadPuzzle(puzzleString: puzzleStr)
                        self.puzzleView.setNeedsDisplay()
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
                        appDelegate.sudoku = SudokuPuzzle()
                        let puzzleStr = appDelegate.randomPuzzle(puzzles: appDelegate.hardPuzzles)
                        appDelegate.sudoku?.loadPuzzle(puzzleString: puzzleStr)
                        self.puzzleView.setNeedsDisplay()
                }))
                self.present(secondaryAlertController, animated: true, completion: nil)
        }))
        
        // Toggles between showing and hiding conflicting cells
        if !self.puzzleView.showConflictingCells {
            alertController.addAction(UIAlertAction(
                title: "Show Conflicting Cells",
                style: .default,
                handler: { (UIAlertAction) -> Void in
                    self.puzzleView.showConflictingCells = !self.puzzleView.showConflictingCells
                    self.puzzleView.setNeedsDisplay()
            }))
        }
        else {
            alertController.addAction(UIAlertAction(
                title: "Hide Conflicting Cells",
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
        
        // Clears all cells, including any entered values or penciled values
        alertController.addAction(UIAlertAction(
            title: "Clear All Cells",
            style: .default,
            handler: { (UIAlertAction) -> Void in
                let secondaryAlertController = UIAlertController(
                    title: "Clearing all entered digits and penciled values!",
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
                        puzzle?.clearAllPencilsForEachCell()
                        self.puzzleView.setNeedsDisplay()
                }))
                self.present(secondaryAlertController, animated: true, completion: nil)
        }))
        
         // ... add other actions ...
//        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//            let popoverPresenter = alertController.popoverPresentationController
//            let menuButtonTag = 12
//            let menuButton = buttonsView.viewWithTag(menuButtonTag)
//            popoverPresenter?.sourceView = menuButton
//            popoverPresenter?.sourceRect = (menuButton?.bounds)!
//        }
        self.present(alertController, animated: true, completion: nil)
    }
}

