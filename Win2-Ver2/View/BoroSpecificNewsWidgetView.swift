//
//  BoroSpecificNewsWidgetView
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/13/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

@IBDesignable class BoroSpecificNewsWidgetView:UIView {
    
    var view: UIView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bigTitleLabel: UILabel!
    @IBOutlet weak var viewMoreButton: UIButton! 

    @IBInspectable var categoryTitle: String? {
        get {
            return categoryLabel.text
        }
        set(title) {
            categoryLabel.text = title
        }
    }
    @IBInspectable var title: String? {
        get {
            return bigTitleLabel.text
        }
        set(title) {
            bigTitleLabel.text = title
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
        let nib = UINib(nibName: "BoroSpecificNewsWidgetView", bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }
    
    
    
}
