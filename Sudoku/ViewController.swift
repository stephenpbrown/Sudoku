//
//  ViewController.swift
//  SudokuLayout
//
//  Created by Stephen Paul Brown on 2/7/17.
//  Copyright © 2017 Stephen Paul Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        NSLog("delete")
    }
    
    @IBAction func pencilButton(_ sender: UIButton) {
        NSLog("pencil")
    }
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        NSLog("menu")
    }
}

