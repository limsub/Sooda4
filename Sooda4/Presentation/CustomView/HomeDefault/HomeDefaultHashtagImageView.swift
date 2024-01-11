//
//  HomeDefaultHashtagImageView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import UIKit

class HomeDefaultHashtagImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp() {
        image = UIImage(named: "hashtag_thin")
    }
    
    func update(_ isBold: Bool) {
        // isBold값에 따라서 이미지 변경
        // 이게 이미지 변경하는게 나을지, 아니면 그냥 tintColor 변경하는게 나을지 고민
        
        image = UIImage(named: isBold ? "hashtag_thick" : "hashtag_thin")
    }
    
}
