//
//  MyProfileView.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import UIKit

class MyProfileView: BaseView {
    
    // 1. 프로필 이미지
    let profileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        return view
    }()
    
    // 2. 보유 코인 이미지
    let coinImageView = {
        let view = UIImageView()
        view.image = .sample1
        return view
    }()
    
    // 3. 보유 코인 레이블
    let coinLabel = {
        let view = UILabel()
        view.text = "120"
        return view
    }()
    
    // 4. 프로필 이름 레이블
    let nameLabel = {
        let view = UILabel()
        view.text = "Allen Danis"
        return view
    }()
    
    
}
