//
//  SignUpActiveButton.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

class SignUpActiveButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        update(.disabled)
        
        setAppFont(.title2, for: .normal)
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    func update(_ type: ButtonEnabledType) {
        self.isEnabled = type.isEnabled
        self.backgroundColor = type.backgroundColor
    }
}
