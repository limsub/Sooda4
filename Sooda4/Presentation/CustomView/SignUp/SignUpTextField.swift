//
//  SignUpTextField.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

class SignUpTextField: UITextField {
    
    convenience init(_ placeholder: String) {
        self.init()
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.appColor(.brand_gray),
                .font: UIFont.appFont(.body)
            ]
        )
    }
    
    func setUp() {
        clipsToBounds = true
        layer.cornerRadius = 8
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
        backgroundColor = UIColor.appColor(.background_secondary)
    }
}
