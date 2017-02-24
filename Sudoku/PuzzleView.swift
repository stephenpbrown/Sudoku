//
//  PuzzleView.swift
//  Sudoku
//
//  Created by Stephen Paul Brown on 2/23/17.
//  Copyright © 2017 Stephen Paul Brown. All rights reserved.
//

import UIKit

class PuzzleView: UIView {
    
    var selected = (row: -1, column: -1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        NSLog("PuzzleView: init(decoder)")
        addMyTapGestureRecognizer()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("PuzzleView: init(frame)")
        addMyTapGestureRecognizer()
    }
    
    override func awakeFromNib() {
        NSLog("awakeFromNib()")
    }
    
    func addMyTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PuzzleView.handleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1 // Number of taps required to activate gesture recognizer
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func BoardRect() -> CGRect {
        let margin : CGFloat = 8
        let size = ceil((min(self.bounds.width, self.bounds.height) - margin)/8.0)*8.0
        let center = CGPoint(x: self.bounds.width/2,
                             y: self.bounds.height/2)
        let boardRect = CGRect(x: center.x - size/2,
                               y: center.y - size/2,
                               width: size, height: size)
        
        return boardRect
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        NSLog("drawRect")
        
        let boardRect = self.BoardRect()
        
        if let context = UIGraphicsGetCurrentContext(){
            
            UIColor.black.setStroke()
            
            let squareSize = boardRect.width/9
            
            // Draw the horizontal lines
            for r in 0 ... 9 {
                if r % 3 == 0 {
                    context.setLineWidth(3.0)
                }
                else {
                    context.setLineWidth(1.0)
                }
                context.stroke(CGRect(x: boardRect.origin.x,
                                      y: boardRect.origin.y + CGFloat(r)*squareSize,
                                      width: boardRect.width, height: 0))
            }
            
            // Draw the vertical lines
            for c in 0 ... 9 {
                if c % 3 == 0 {
                    context.setLineWidth(3.0)
                }
                else {
                    context.setLineWidth(1.0)
                }
                context.stroke(CGRect(x: boardRect.origin.x + CGFloat(c)*squareSize,
                                      y: boardRect.origin.y,
                                      width: 0, height: boardRect.height))
            }
            
            if selected.row >= 0 && selected.column >= 0 {
                UIColor.lightGray.setFill()
                let x = boardRect.origin.x + CGFloat(selected.column)*squareSize + 1
                let y = boardRect.origin.y + CGFloat(selected.row)*squareSize + 1
                
                context.fill(CGRect(x: x, y: y, width: squareSize-2, height: squareSize-2))
            }
        }
            
        let boldFont = UIFont(name: "Helvetica-Bold", size: 30)
        let fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.black]
        
        // ...
        let number = 3 // TEMP YO
        let gridSize = boardRect.width
        let delta = gridSize/3
        let d = delta/3
        let gridOrigin = CGPoint(x: boardRect.origin.x, y: boardRect.origin.y)
        let row = 1
        let col = 0
        
        let text = "\(number)" as NSString
        let textSize = text.size(attributes: fixedAttributes)
        let x = gridOrigin.x + CGFloat(col)*d + 0.5*(d - textSize.width)
        let y = gridOrigin.y + CGFloat(row)*d + 0.5*(d - textSize.height)
        let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
        text.draw(in: textRect, withAttributes: fixedAttributes)
    }
    
    func handleTap(_ sender : UIGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        NSLog("Tap!")
        
        //    ... compute gridOrigin and d as done in drawRect ...
        let boardRect = self.BoardRect()
        let gridSize = boardRect.width
        let delta = gridSize/3
        let d = delta/3
        let gridOrigin = CGPoint(x: boardRect.origin.x, y: boardRect.origin.y)
        
        let col = Int((tapPoint.x - gridOrigin.x)/d)
        let row = Int((tapPoint.y - gridOrigin.y)/d)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku // fetch model data
        
        if 0 <= col && col < 9 && 0 <= row && row < 9 { // if inside puzzle bounds
            if (!puzzle!.numberIsFixedAtRow(row: row, column: col)) { // and not a "fixed number"
                if (row != selected.row || col != selected.column) { // and not already selected
                    NSLog("Highlight")
                    selected.row = row // then select cell
                    selected.column = col
                    setNeedsDisplay() // request redraw
                }
            }
        }
    }
}
