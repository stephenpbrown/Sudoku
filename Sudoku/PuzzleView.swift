//
//  PuzzleView.swift
//  Sudoku
//
//  Created by Stephen Paul Brown on 2/23/17.
//  Copyright © 2017 Stephen Paul Brown. All rights reserved.
//

import UIKit

class PuzzleView: UIView {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        NSLog("ChessView: init(decoder)")
        //addMyTapGestureRecognizer()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("ChessView: init(frame)")
        //addMyTapGestureRecognizer()
    }
    
    override func awakeFromNib() {
        NSLog("awakeFromNib()")
    }
    
    func BoardRect() -> CGRect {
        let margin : CGFloat = 10
        let size = ceil((min(self.bounds.width, self.bounds.height) - margin)/9.0)*9.0
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
        
        if let context = UIGraphicsGetCurrentContext(){

            let boardRect = self.BoardRect()
            
            context.setLineWidth(3.0)
            UIColor.black.setStroke()
            
            //context.stroke(boardRect)
            
            let squareSize = boardRect.size.width/9
            for r in 0 ..< 9 {
                if r % 3 == 0 {
                    context.setLineWidth(3.0)
                }
                else {
                    context.setLineWidth(1.0)
                }
//                context.stroke(CGRect(x: boardRect.origin.x,
//                                      y: boardRect.origin.y + CGFloat(r)*squareSize,
//                                      width: boardRect.width, height: boardRect.height))
                
                context.stroke(CGRect(x: boardRect.origin.x,
                                      y: boardRect.origin.y + CGFloat(r)*squareSize,
                                      width: boardRect.width, height: 0))
            }
            
            for c in 0 ..< 9 {
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
        }
            
        let boldFont = UIFont(name: "Helvetica-Bold", size: 30)
        let fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.black]
        
        // ...
        let number = 3 // TEMP YO
        let gridSize = self.bounds.width - 8
        let delta = gridSize/3
        let d = delta/3
        let gridOrigin = CGPoint(x: 0, y: 0)
        let row = 0
        let col = 0
        
        let text = "\(number)" as NSString
        let textSize = text.size(attributes: fixedAttributes)
        let x = gridOrigin.x + CGFloat(col)*d + 0.5*(d - textSize.width)
        let y = gridOrigin.y + CGFloat(row)*d + 0.5*(d - textSize.height)
        let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
        text.draw(in: textRect, withAttributes: fixedAttributes)
    }
    
//    func handleTap(sender : UIGestureRecognizer) {
//        let tapPoint = sender.location(in: self)
//        
//        //    ... compute gridOrigin and d as done in drawRect ...
//        
//        let col = Int((tapPoint.x - gridOrigin.x)/d)
//        let row = Int((tapPoint.y - gridOrigin.y)/d)
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let puzzle = appDelegate.sudoku // fetch model data
//        
//        if 0<=col&&col<9&&0<=row&&row<9{ //if inside puzzle bounds 
//            if (!puzzle.numberIsFixedAtRow(row, column: col)) { // and not a "fixed number" 
//                if (row != selected.row || col != selected.column) { // and not already selected
//                    selected.row = row // then select cell
//                    selected.column = col
//                    setNeedsDisplay() // request redraw
//                }
//            }
//        }
//    }
}
