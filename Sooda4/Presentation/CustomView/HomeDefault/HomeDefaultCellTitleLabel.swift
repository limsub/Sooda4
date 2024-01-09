//
//  HomeDefaultCellTitleLabel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import UIKit

class HomeDefaultCellTitleLabel: UILabel {
    
    convenience init(_ text: String) {
        self.init()
        
        self.text = text
        setUp()
    }
    
    func setUp() {
        setAppFont(.body)
        textColor = UIColor.appColor(.text_secondary)
    }
    
    func update(_ isBold: Bool) {
        // 폰트 변경 + 색상 변경
        
        if isBold {
            setAppFont(.bodyBold)
            textColor = UIColor.appColor(.text_primary)
        } else {
            setUp()
        }
    }
}
