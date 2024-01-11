//
//  HomeDefaultSectionChevronImageView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import UIKit

class HomeDefaultSectionChevronImageView: UIImageView {
    
    // 고민 : asset에 있는 이미지를 사용해도 자연스럽게 돌아갈까?
    // 만약 그게 안된다면 그냥 systemImage 사용하는 게 나을수도
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        image = UIImage(named: "chevron_right")
    }
    
    func update(_ isOpend: Bool) {
        print("isOpened(Bool) 값에 따라 이미지 변환 (애니메이션)")
    }
}
