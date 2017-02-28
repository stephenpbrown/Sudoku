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
        
        if pencilEnabled {
            //puzzle?.setPencil(n: tag, row: puzzle, column: <#T##Int#>)
        }
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        NSLog("delete")
    }
    
    @IBAction func pencilButton(_ sender: UIButton) {
        NSLog("pencil")
        
        pencilEnabled = !pencilEnabled   // toggle
        sender.isSelected = pencilEnabled
    }
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        NSLog("menu")
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let puzzle = appDelegate.sudoku
//        
//        let alertController = UIAlertController(
//            title: "Main Menu",
//            message: nil,
//            preferredStyle: .actionSheet)
//        
//        alertController.addAction(UIAlertAction(
//            title: "Cancel",
//            style: .cancel,
//            handler: nil))
//        alertController.addAction(UIAlertAction(
//            title: "New Easy Game",
//            style: .default,
//            handler: { (UIAlertAction) -> Void in
//                let puzzleStr = randomPuzzle(appDelegate.simplePuzzles)
//                puzzle.loadPuzzle(puzzleStr)
//                self.selectFirstAvailableCell()
//                self.puzzleView.setNeedsDisplay()}))
//        
//         ... add other actions ...
//        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//            let popoverPresenter = alertController.popoverPresentationController
//            let menuButtonTag = 12
//            let menuButton = buttonsView.viewWithTag(menuButtonTag)
//            popoverPresenter?.sourceView = menuButton
//            popoverPresenter?.sourceRect = (menuButton?.bounds)!
//        }
//        self.present(alertController, animated: true, completion: nil)
    }
}

