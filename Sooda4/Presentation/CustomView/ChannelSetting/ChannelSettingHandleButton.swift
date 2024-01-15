//
//  ChannelSettingHandleButton.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

class ChannelSettingHandleButton: UIButton {
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(text: String, isRed: Bool) {
        
        setTitle(text, for: .normal)
        setAppFont(.title2, for: .normal)
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        
        let buttonColor = UIColor.appColor(
            isRed ? .brand_error : .brand_black
        )
        
        setTitleColor(buttonColor, for: .normal)
        layer.borderColor = buttonColor.cgColor
    }
    
    
}
