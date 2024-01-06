//
//  UIFont+AppFont.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit


extension UIFont {
    static func appFont(_ appFont: FontSet) -> UIFont {
        return UIFont(name: appFont.fontName, size: appFont.size)!
    }
}




