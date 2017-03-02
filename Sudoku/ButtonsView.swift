//
//  ButtonsView.swift
//  Sudoku
//
//  Created by Stephen Paul Brown on 3/2/17.
//  Copyright © 2017 Stephen Paul Brown. All rights reserved.
//

import UIKit

class ButtonsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        let tileImage = UIImage(named: "ButtonTileSquared")
        for tag in 1 ... 12 {
            let button = self.viewWithTag(tag) as! UIButton
            button.setBackgroundImage(tileImage, for: UIControlState())
            // button.backgroundColor = UIColor.clear // transparent
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
