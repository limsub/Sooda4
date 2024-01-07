//
//  UILabel+AppFont.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

extension UILabel {
    
    func setAppFont(_ appFont: FontSet) {
        
        if let text = text {
            
            let font = UIFont.appFont(appFont)
            
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = appFont.lineHeight
            style.minimumLineHeight = appFont.lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font as Any,
                .paragraphStyle: style
            ]
            
            let attrString = NSAttributedString(
                string: text,
                attributes: attributes
            )
            
            self.attributedText = attrString
        }
        
    }
}