//
//  PaddedTextField.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 11/15/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class PaddedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCustomPaddingAndBorderUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addCustomPaddingAndBorderUI()
    }
    
    func addCustomPaddingAndBorderUI() {
        //Place your initialization code here
        let leftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
        leftView.backgroundColor = UIColor.clear
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewMode.always;
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(rgba: "#BBBCBC").cgColor
    }


}
