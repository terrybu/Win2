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
    var applyButtonPressedHandler: ((_ sender: UIButton) -> Void)?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
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
            applyButton.setTitle(title, for: UIControlState())
        }
    }
    @IBInspectable var applyButtonImage: UIImage? {
        get {
            return applyButton.backgroundImage(for: UIControlState())
        }
        set(image) {
            applyButton.setBackgroundImage(image, for: UIControlState())
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
        let nib = UINib(nibName: "ApplyWidgetView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

}
