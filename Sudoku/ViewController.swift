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
        
        if pencilEnabled && !(puzzle?.isSetPencil(n: tag, row: row, column: column))! && puzzle?.numberAtRow(row: row, column: column) == 0 {
            puzzle?.setPencil(n: tag, row: row, column: column)
        }
        else if !pencilEnabled && !(puzzle?.anyPencilSetAtCell(row: row, column: column))! {
            puzzle?.setNumber(number: tag, row: row, column: column)
        }
        else if pencilEnabled && (puzzle?.isSetPencil(n: tag, row: row, column: column))! {
            puzzle?.clearPencil(n: tag, row: row, column: column)
        }
        
        puzzleView.setNeedsDisplay()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        // let tag = sender.tag
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        
        let row = puzzleView.selected.row
        let column = puzzleView.selected.column

        
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
        alertController.addAction(UIAlertAction(
            title: "New Easy Game",
            style: .default,
            handler: { (UIAlertAction) -> Void in
                appDelegate.sudoku = SudokuPuzzle()               
                let puzzleStr = appDelegate.randomPuzzle(puzzles: appDelegate.simplePuzzles)
                appDelegate.sudoku?.loadPuzzle(puzzleString: puzzleStr)
                self.puzzleView.setNeedsDisplay()
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

