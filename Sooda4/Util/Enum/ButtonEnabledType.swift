//
//  ButtonEnabledType.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

enum ButtonEnabledType {
    case enabled, disabled
    
    var backgroundColor: UIColor {
        switch self {
        case .enabled:
            return UIColor.appColor(.brand_green)
        case .disabled:
            return UIColor.appColor(.brand_inactive)
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .enabled:
            return true
        case .disabled:
            return false
        }
    }
}
