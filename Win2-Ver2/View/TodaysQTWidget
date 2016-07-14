//
//  TodaysQTWidget.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/12/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

@IBDesignable class TodaysQTWidget: UIView {

    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TodaysQTWidget", bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }

}
