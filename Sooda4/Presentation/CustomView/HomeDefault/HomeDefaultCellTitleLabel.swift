//
//  HomeDefaultCellTitleLabel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import UIKit

class HomeDefaultCellTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            setAppFont(.body)
            textColor = UIColor.appColor(.text_secondary)
        }
    }
    
    func setText(_ text: String) {
        self.text = text
        setUp()
    }
}
