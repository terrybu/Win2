//
//  LongApplyWidgetView.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/6/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

@IBDesignable class LongApplyWidgetView: UIView {
    
    var view: UIView!
    var applyButtonPressedHandler: ((sender: UIButton) -> Void)?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBAction func applyButtonPressed(sender: UIButton) {
        if let handler = applyButtonPressedHandler {
            handler(sender: sender)
        }
    }
    
    @IBInspectable var title: String? {
        get {
            return titleLabel.text
        }
        set(title) {
            titleLabel.text = title
        }
    }

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
        let nib = UINib(nibName: "LongApplyWidgetView", bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }

}
