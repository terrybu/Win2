//
//  NewsArticleView
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/7/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

@IBDesignable class NewsArticleView: UIView {
    
    var view: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryLabel: PaddedLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var blackOverlay: UIView?

    var title: String? {
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
        let nib = UINib(nibName: "NewsArticleView", bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = UIColor.whiteColor().CGColor
        categoryLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        if blackOverlay == nil {
            blackOverlay = UIView(frame:self.frame)
            blackOverlay!.backgroundColor = UIColor.blackColor()
            blackOverlay!.alpha = 0.4
            self.backgroundImageView.addSubview(blackOverlay!)
        }
    }
    
}
