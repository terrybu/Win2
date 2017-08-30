//
//  StringExtension.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/2/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

extension String {
    
    subscript(integerIndex: Int) -> String {
        let index = characters.index(startIndex, offsetBy: integerIndex)
        return String(self[index] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substring(with: (characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)))
    }
}
