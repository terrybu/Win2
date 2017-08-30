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
    var applyButtonPressedHandler: ((_ sender: UIButton) -> Void)?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        if let handler = applyButtonPressedHandler {
            handler(sender)
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
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LongApplyWidgetView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

}
