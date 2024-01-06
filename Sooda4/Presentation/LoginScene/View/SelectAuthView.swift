//
//  SelectAuthView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import SnapKit

class SelectAuthView: BaseView {
    
    // MARK: - 임시
    let tempLabel = UILabel()
    let b1 = UIButton()
    let b2 = UIButton()
    let b3 = UIButton()
    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
        
        tempLabel.text = "로그인 선택 뷰"
        tempLabel.backgroundColor = .yellow
        
        b1.setTitle("소셜 로그인 성공", for: .normal)
        b2.setTitle("이메일 회원가입", for: .normal)
        b3.setTitle("이메일 로그인", for: .normal)
        [b1, b2, b3].forEach { item in
            item.backgroundColor = .brown
        }
        
        self.addSubview(tempLabel)
        self.addSubview(b1)
        self.addSubview(b2)
        self.addSubview(b3)
        tempLabel.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(self)
        }
        b1.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(tempLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).inset(30)
        }
        b2.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(b1)
            make.leading.equalTo(b1.snp.trailing).offset(40)
        }
        b3.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(b1)
            make.leading.equalTo(b2.snp.trailing).offset(40)
        }
    }
}
