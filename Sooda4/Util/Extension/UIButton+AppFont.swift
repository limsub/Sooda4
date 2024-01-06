//
//  UIButton+AppFont.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

extension UIButton {
    
    func setAppFont(_ appFont: FontSet, for state: UIControl.State) {
        
        
        if let title = title(for: state) {
            
            let font = UIFont.appFont(appFont)
            
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = appFont.lineHeight
            style.minimumLineHeight = appFont.lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font as Any,
                .paragraphStyle: style
            ]
            
            let attrString = NSAttributedString(
                string: title,
                attributes: attributes
            )
            
            setAttributedTitle(attrString, for: state)
        }
    }
}
