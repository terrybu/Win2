//
//  GalleryCell.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/30/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.masksToBounds = true
    }
    
}
