//
//  AppDelegate.swift
//  SudokuLayout
//
//  Created by Stephen Paul Brown on 2/7/17.
//  Copyright © 2017 Stephen Paul Brown. All rights reserved.
//

import UIKit

func sandboxArchivePath() -> String {
    let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    return dir.appendingPathComponent("savedPuzzle.plist")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sudoku : SudokuPuzzle?
    
    func getPuzzles(name : String) -> [String] {
        let path = Bundle.main.path(forResource: name, ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        return array as! [String]
    }
    
    lazy var simplePuzzles = { () -> [String] in
        let path = Bundle.main.path(forResource: "simple", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        return array as! [String]
    }()
    
    lazy var hardPuzzles = { () -> [String] in
        let path = Bundle.main.path(forResource: "hard", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        return array as! [String]
    }()
    
    func randomPuzzle(puzzles: [String]) -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(puzzles.count)))
        return puzzles[randomIndex]
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.sudoku = SudokuPuzzle()
        
        let archiveName = sandboxArchivePath()
        if FileManager.default.fileExists(atPath: archiveName) { // If saved file exists, load it, otherwise load random puzzle
            NSLog("Loading puzzle")
            let savedPuzzle = NSArray(contentsOfFile: archiveName) // Grab saved state and cast it to a double int array
            sudoku!.puzzle = savedPuzzle as! [[SudokuPuzzle.cell]]
        }
        else {
            NSLog("Loading new puzzle")
            let randomPuzzle = self.randomPuzzle(puzzles: simplePuzzles)
            self.sudoku!.loadPuzzle(puzzleString: randomPuzzle)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        NSLog("Entered background")
        let archiveName = sandboxArchivePath()
        let savedPuzzle : NSArray = sudoku!.puzzle as NSArray // Saved the puzzle as an NS array
        savedPuzzle.write(toFile : archiveName, atomically : true) // Write to the archive
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

