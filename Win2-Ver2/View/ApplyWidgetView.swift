//
//  ApplyWidgetView.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/6/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

@IBDesignable class ApplyWidgetView: UIView {

    var view: UIView!
    var applyButtonPressedHandler: ((sender: UIButton) -> Void)?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
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
    @IBInspectable var backgroundImage: UIImage? {
        get {
            return backgroundImageView.image
        }
        set(image) {
            backgroundImageView.image = image
        }
    }
    @IBInspectable var applyButtonTitle: String? {
        get {
            return applyButton.titleLabel?.text
        }
        set(title) {
            applyButton.setTitle(title, forState: UIControlState.Normal)
        }
    }
    @IBInspectable var applyButtonImage: UIImage? {
        get {
            return applyButton.backgroundImageForState(UIControlState.Normal)
        }
        set(image) {
            applyButton.setBackgroundImage(image, forState: UIControlState.Normal)
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
        let nib = UINib(nibName: "ApplyWidgetView", bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }

}
