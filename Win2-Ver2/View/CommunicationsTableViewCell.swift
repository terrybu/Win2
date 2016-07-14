//
//  CommunicationsTableViewCell.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/16/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class CommunicationsTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: PaddedLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var blackOverlay: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = UIColor.whiteColor().CGColor
        categoryLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        blackOverlay = UIView(frame:self.backgroundImageView.frame)
        blackOverlay!.backgroundColor = UIColor.blackColor()
        blackOverlay!.alpha = 0.3
        backgroundImageView.addSubview(self.blackOverlay!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
