//
//  PaddedLabel.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/7/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {

    /*
    
    This is to add left and right padding to the text inside the label
    drawTextInRect with UIEdgeInsetsInsetRect is not enough because it truncates the lable afterwards
    This basically handles the resizing of the label to accommodate the padding
    
    */
    
    var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width  += (edgeInsets.left + edgeInsets.right);
        rect.size.height += (edgeInsets.top + edgeInsets.bottom);
        
        return rect
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}