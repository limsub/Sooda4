//
//  ColorSet.swift
//  Sooda4
//
//  Created by 임승섭 on 1/4/24.
//

import Foundation

enum ColorSet {
    
    case brand_green
    case brand_error
    case brand_inactive
    case brand_black
    case brand_gray
    case brand_white
    
    case text_primary
    case text_secondary
    
    case background_primary
    case background_secondary
    
    case view_seperator
    case view_alpha
    
    
    var hexCode: String {
        
        switch self {
        case .brand_green:
            return "#FB8B24"
        case .brand_error:
            return "#E9666B"
        case .brand_inactive:
            return "#AAAAAA"
        case .brand_black:
            return "#000000"
        case .brand_gray:
            return "#DDDDDD"
        case .brand_white:
            return "#FFFFFF"
        case .text_primary:
            return "#1C1C1C"
        case .text_secondary:
            return "#606060"
        case .background_primary:
            return "#F6F6F6"
        case .background_secondary:
            return "#FFFFFF"
        case .view_seperator:
            return "#ECECEC"
        case .view_alpha:
            return "#000000"
        }
    }
}

