//
//  ExpandableAboutView.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/5/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

//IBDesignable lets you use Interface Builder and Storyboard to see the changes you are making to your custom view right inside Storyboard after you make the change
//Without it, whatever changes you make in the XIB file of your custom view won't be seen in storyboard. Rather, storyboard will always just show the initial version of what your xib used to look like. IBDesignable lets you work around that. 

@IBDesignable class ExpandableAboutView: UIView {
    
    var view: UIView!
    var handler: ExpandableAboutViewHandler?
    var expanded: Bool {
        didSet {
            if expanded == false {
                //if expanded becomes false, then it means it just closed. Arrow should point down
                arrowImageButton.setImage(UIImage(named: "btn_down_w"), forState: UIControlState.Normal)
            } else {
                arrowImageButton.setImage(UIImage(named: "btn_up_w"), forState: UIControlState.Normal)
            }
        }
    }
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var arrowImageButton: UIButton!

    //IBInspectable lets you read and write properties right in the inspector view of interface builder. Without it, there's no way for you to change properties of your custom view UI from storyboard
    @IBInspectable var aboutLabelTitle: String? {
        get {
            return aboutLabel.text
        }
        set(aboutLabelTitle) {
            aboutLabel.text = aboutLabelTitle
        }
    }
    @IBInspectable var titleLabeltitle: String? {
        get {
            return titleLabel.text
        }
        set(titleLabeltitle) {
            titleLabel.text = titleLabeltitle
        }
    }
    @IBInspectable var textViewContentText: String? {
        get {
            return textView.text
        }
        set(textViewContentText) {
            textView.text = textViewContentText
        }
    }
    
     override init(frame: CGRect) {
        self.expanded = false
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.expanded = false
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
        let nib = UINib(nibName: "ExpandableAboutView", bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }

}
