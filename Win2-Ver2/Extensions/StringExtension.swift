//
//  StringExtension.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/2/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

extension String {
    
    subscript(integerIndex: Int) -> String {
        let index = startIndex.advancedBy(integerIndex)
        return String(self[index] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}