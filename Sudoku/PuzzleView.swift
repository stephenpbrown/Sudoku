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
            
            // Highlights the selected cell
            if selected.row >= 0 && selected.column >= 0 {
                UIColor.lightGray.setFill()
                let x = boardRect.origin.x + CGFloat(selected.column)*squareSize
                let y = boardRect.origin.y + CGFloat(selected.row)*squareSize
                
                context.fill(CGRect(x: x, y: y, width: squareSize, height: squareSize))
            }
            
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
        }
        
        let boldFont = UIFont(name: "Helvetica-Bold", size: 30)
        var fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.black]
        
        let pencilFont = UIFont(name: "Helvetica-Bold", size: 10)
        let pencilAttributes = [NSFontAttributeName : pencilFont!, NSForegroundColorAttributeName : UIColor.black]
        
        // Temp number, row, and col
        //let number = 3 // TEMP YO
        //let row = 1
        //let col = 0
        
        let gridSize = boardRect.width
        let delta = gridSize/3
        let d = delta/3
        let s = d/3
        var s2 : CGFloat = 0
        let gridOrigin = boardRect.origin
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku // fetch model data
        
        // Set the numbers in the cells
        for row in 0 ..< 9 {
            for col in 0 ..< 9 {
                if puzzle!.puzzle[row][col].number != 0 {
                    
                    // Check to see if the number is fixed. Print red if it is
                    if puzzle!.numberIsFixedAtRow(row: row, column: col) {
                        fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.darkGray]
                    }
                    else {
                        fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.black]
                    }
                    
                    let text = "\(puzzle!.puzzle[row][col].number)" as NSString
                    let textSize = text.size(attributes: fixedAttributes)
                    let x = gridOrigin.x + CGFloat(col)*d + 0.5*(d - textSize.width)
                    let y = gridOrigin.y + CGFloat(row)*d + 0.5*(d - textSize.height)
                    let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                    text.draw(in: textRect, withAttributes: fixedAttributes)
                }
                
                else if puzzle!.anyPencilSetAtCell(row: row, column: col) {
                    for n in 1 ..< 10 {
                        if puzzle!.isSetPencil(n: n, row: row, column: col) {
                            
                            // CONTINUE HERE
                            if n == 1 {
                                s2 = s
                            }
                            else {
                                s2 = s*CGFloat(n)*2
                            }
                                
                            let text = "\(n)" as NSString
                            let textSize = text.size(attributes: pencilAttributes)
                            let x = gridOrigin.x + CGFloat(col)*d + 0.5*(s2 - textSize.width)
                            let y = gridOrigin.y + CGFloat(row)*d + 0.5*(s - textSize.height)
                            let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                            text.draw(in: textRect, withAttributes: pencilAttributes)
                        }
                    }
                }
            }
        }
    }
    
    func handleTap(_ sender : UIGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        NSLog("Tap!")
        
        //    ... compute gridOrigin and d as done in drawRect ...
        let boardRect = self.BoardRect()
        let gridSize = boardRect.width
        let delta = gridSize/3
        let d = delta/3
        let gridOrigin = boardRect.origin
        
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
    
    // Programically set buttons
    let buttonTagsPortrait = [ // 2x6 button layout 
        [1, 2, 3, 4, 5, 11], // tags assigned in IB
        [6, 7, 8, 9, 10, 12]
    ]
    
    let buttonTagsPortraitTall = [ // 3x4 layout
        [1, 2, 3, 11],
        [4, 5, 6, 10],
        [7, 8, 9, 12]
    ]
    
    let buttonTagsLandscape = [ // 6x2 layout
        [1,6],
        [2,7],
        [3,8],
        [4,9],
        [5,10],
        [11,12]
    ]
    
    let buttonTagsLandscapeTall = [ // 4x3 layout
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
        [10, 11, 12]
    ]
    
    let aspectRatiosForLayouts : [Float] = [
        3.0, // 2x6
        4.0/3, // 3x4
        1.0/3, // 6x2
        3.0/4 // 4x3
    ]
    
    override func layoutSubviews() {
        super.layoutSubviews() // let Auto Layout finish
        let aspectRatio = Float(self.bounds.size.width / self.bounds.size.height)
        var closestLayout = 0
        var closestLayoutDiff = fabsf(aspectRatio - aspectRatiosForLayouts[0])
        for i in 1 ..< 4 {
            let diff = fabsf(aspectRatio - aspectRatiosForLayouts[i])
            if (diff < closestLayoutDiff) {
                closestLayout = i
                closestLayoutDiff = diff
            }
        }
        
        let buttonTagsFlavors = [
            buttonTagsPortrait, buttonTagsPortraitTall, buttonTagsLandscape, buttonTagsLandscapeTall
        ]
        
        let buttonTags = buttonTagsFlavors[closestLayout]
        
        func integersWithSum(sum : Int, count : Int) -> [Int] {
            var ints = [Int](repeating: sum / count, count: count)
            let r = sum % count
            for i in 0 ..< r {ints[i] += 1}
            return ints
        }
        
        let inset = 1
        let W = Int(self.bounds.width) - 2*inset, H = Int(self.bounds.height) - 2*inset
        let numColumns = buttonTags[0].count, numRows = buttonTags.count
        let widths  = integersWithSum(sum: W, count: numColumns)
        let heights = integersWithSum(sum: H, count: numRows)
        var y = CGFloat(inset)
        
        for r in 0 ..< numRows {
            let h = CGFloat(heights[r])
            var x = CGFloat(inset)
            for c in 0 ..< numColumns {
                let w = CGFloat(widths[c])
                let button = self.viewWithTag(buttonTags[r][c])
                button?.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                button?.center = CGPoint(x: (x + w/2), y: (y + h/2))
                x += w
            }
            y += h
        }
    }
}
