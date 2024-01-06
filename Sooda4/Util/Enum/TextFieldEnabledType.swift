//
//  TextFieldEnabledType.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

enum TextFieldEnabledType {
    case enabled, disabled
    
    var titleTextColor: UIColor {
        switch self {
        case .enabled:
            return UIColor.appColor(.brand_black)
        case .disabled:
            return UIColor.appColor(.brand_error)
        }
    }
}
