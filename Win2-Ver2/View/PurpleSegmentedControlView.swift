//
//  PurpleSegmentedControlView.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 11/26/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

protocol PurpleSegmentedControlViewDelegate {
    
    func didPressMyFeedButton()
    func didPressPIFeedButton()
    
}

enum HomeScreenSegmentedControlIndex {
    case myFeed
    case piFeed
}

private let purpleBarSelectorBelowLabelHeightPadding:CGFloat = 1

@IBDesignable class PurpleSegmentedControlView: UIView {
    
    var view: UIView!
    var selectedSegment: HomeScreenSegmentedControlIndex
    var delegate: PurpleSegmentedControlViewDelegate?
    @IBOutlet var purpleSegmentIndicatorBarImageView: UIImageView!
    @IBOutlet var myFeedButton: UIButton!
    @IBOutlet var piFeedButton: UIButton!
    
    @IBAction func myFeedButtonPressed(_ sender: UIButton) {
        sender.setTitleColor(UIColor.In2DeepPurple(), for: UIControlState())
        piFeedButton.setTitleColor(UIColor(rgba: "#bbbcbc"), for: UIControlState())
        purpleSegmentIndicatorBarImageView.frame = CGRect(x: 0, y: myFeedButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:view.frame.size.width/2, height: 4)
        delegate?.didPressMyFeedButton()
    }
    @IBAction func piFeedButtonPressed(_ sender: UIButton) {
        sender.setTitleColor(UIColor.In2DeepPurple(), for: UIControlState())
        myFeedButton.setTitleColor(UIColor(rgba: "#bbbcbc"), for: UIControlState())
        purpleSegmentIndicatorBarImageView.frame = CGRect(x: view.frame.width/2, y: myFeedButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:view.frame.size.width/2, height: 4)
        delegate?.didPressPIFeedButton()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        self.selectedSegment = HomeScreenSegmentedControlIndex.myFeed
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.selectedSegment = HomeScreenSegmentedControlIndex.myFeed
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
        let nib = UINib(nibName: "PurpleSegmentedControlView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    

}
