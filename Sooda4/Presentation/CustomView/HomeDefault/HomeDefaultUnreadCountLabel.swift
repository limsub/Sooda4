//
//  HomeDefaultUnreadCountLabel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import UIKit

class HomeDefaultUnreadCountLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp() {
        backgroundColor = UIColor.appColor(.brand_green)
        clipsToBounds = true
        layer.cornerRadius = 8
        textColor = UIColor.appColor(.brand_white)
        textAlignment = .center
        setAppFont(.caption)
    }
    
    func setText(_ count: Int ) {
        self.text = "\(count)"
        setAppFont(.caption)
        self.textAlignment = .center
        
        self.isHidden = count == 0
    }
}
