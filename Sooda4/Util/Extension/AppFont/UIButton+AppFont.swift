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
                .paragraphStyle: style,
                .baselineOffset: (appFont.lineHeight - font.lineHeight)/4
            ]
            
            let attrString = NSAttributedString(
                string: title,
                attributes: attributes
            )
            
            setAttributedTitle(attrString, for: state)
        }
    }
    
    
    func makeEmailSignUpButton(_ appFont: FontSet, for state: UIControl.State) {
        guard let title = title(for: state) else {
            return
        }

        let font = UIFont.appFont(appFont)

        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = appFont.lineHeight
        style.minimumLineHeight = appFont.lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .paragraphStyle: style,
            .baselineOffset: (appFont.lineHeight - font.lineHeight) / 4
        ]

        let attributedTitle = NSMutableAttributedString(string: title, attributes: attributes)

        let blackRange = (title as NSString).range(of: "또는")
        if blackRange.location != NSNotFound {
            attributedTitle.addAttribute(.foregroundColor, value: UIColor.appColor(.brand_black), range: blackRange)
        }

        let greenRange = (title as NSString).range(of: "새롭게 회원가입 하기")
        if greenRange.location != NSNotFound {
            attributedTitle.addAttribute(.foregroundColor, value: UIColor.appColor(.brand_green), range: greenRange)
        }

        setAttributedTitle(attributedTitle, for: state)
    }
}
