//
//  FBPhoto.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/30/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import Foundation

class FBPhoto {
    
    var id: String
    var albumSizePicURLString: String
    
    init(id: String, albumPicURLString: String) {
        self.id = id
        self.albumSizePicURLString = albumPicURLString
    }
    
}