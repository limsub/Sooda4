//
//  ChannelChattingSendButton.swift
//  Sooda4
//
//  Created by 임승섭 on 1/18/24.
//

import UIKit

class ChannelChattingSendButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "icon_send_enabled"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ type: SendButtonType) {
        
        self.setImage(
            UIImage(named: type.buttonImageName),
            for: .normal
        )
    }
    
    enum SendButtonType {
        case enabled
        case disabled
        
        var buttonImageName: String {
            switch self {
            case .enabled: return "icon_send_enabled"
            case .disabled: return "icon_send_disabled"
            }
        }
    }
    
}
