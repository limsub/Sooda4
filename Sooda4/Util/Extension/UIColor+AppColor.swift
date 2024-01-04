//
//  UIColor+AppColor.swift
//  Sooda4
//
//  Created by 임승섭 on 1/4/24.
//

import UIKit

extension UIColor {
    static func appColor(_ colorset: ColorSet) -> UIColor {
        return UIColor(hexCode: colorset.hexCode)
    }
}


