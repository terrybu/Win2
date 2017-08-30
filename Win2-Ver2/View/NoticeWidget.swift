//
//  NoticeWidget.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

@IBDesignable class NoticeWidget: UIView {

    var view: UIView!
    
    @IBOutlet weak var noticeTitleLabel: UILabel!
    @IBOutlet weak var noticeBodyLabel: UILabel!
    @IBOutlet weak var viewMoreNoticeButton: UIButton!
    
    var title: String {
        get {
            return noticeTitleLabel.text!
        }
        set(title) {
            noticeTitleLabel.text = title
        }
    }
    var body: String {
        get {
            return noticeBodyLabel.text!
        }
        set(body) {
            noticeBodyLabel.text = body
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
        let nib = UINib(nibName: "NoticeWidget", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
}
