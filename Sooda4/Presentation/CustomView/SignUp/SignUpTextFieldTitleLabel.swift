//
//  SignUpTextFieldTitleLabel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

class SignUpTextFieldTitleLabel: UILabel {

    convenience init(_ text: String) {
        self.init()
        
        self.text = text
        setUp()
    }
    
    func setUp() {
        setAppFont(.title2)
    }
    
    func update(_ type: TextFieldEnabledType) {
        self.textColor = type.titleTextColor
    }
}
