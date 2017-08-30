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
    
    var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width  += (edgeInsets.left + edgeInsets.right);
        rect.size.height += (edgeInsets.top + edgeInsets.bottom);
        
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}
