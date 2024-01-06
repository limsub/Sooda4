//
//  SignUpActiveButton.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

class SignUpActiveButton: UIButton {
    
    
    convenience init(_ title: String) {
        self.init()
        
        setTitle(title, for: .normal)
        setUp()
    }

    
    func setUp() {
        update(.disabled)
        
        setAppFont(.title2, for: .normal)
        setTitleColor(UIColor.appColor(.brand_white), for: .normal)
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    func update(_ type: ButtonEnabledType) {
        self.isEnabled = type.isEnabled
        self.backgroundColor = type.backgroundColor
    }
}
