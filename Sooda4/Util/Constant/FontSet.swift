//
//  FontSet.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation

enum FontSet {
    case title1
    case title2
    case bodyBold
    case body
    case caption
    
    var size: CGFloat {
        switch self {
        case .title1:
            return 22
        case .title2:
            return 14
        case .bodyBold:
            return 13
        case .body:
            return 13
        case .caption:
            return 12
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .title1:
            return 30
        case .title2:
            return 20
        case .bodyBold:
            return 18
        case .body:
            return 18
        case .caption:
            return 18
        }
    }
    
    var fontName: String {
        switch self {
        case .title1, .title2, .bodyBold:
            return "SFPro-Bold"
        case .body, .caption:
            return "SFPro-Regular"
            
        }
    }
}
