//
//  HomeDefaultSectionTitleLabel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import UIKit

class HomeDefaultSectionTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        setAppFont(.title2)
    }
    
    
    func setText(_ text: String) {
        self.text = text
        setUp()
    }
}
