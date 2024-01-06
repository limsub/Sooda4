//
//  SignUpView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import SnapKit

class SignUpView: BaseView {
    
    // MARK: - 임시
    let tempLabel = UILabel()
    let nextButton = UIButton()
    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
        
        tempLabel.text = "회원가입 뷰"
        tempLabel.backgroundColor = .yellow
        
        nextButton.setTitle("회원가입 성공", for: .normal)
        nextButton.backgroundColor = .blue
        
        self.addSubview(tempLabel)
        self.addSubview(nextButton)
        tempLabel.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(self)
        }
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.equalTo(self)
            make.top.equalTo(tempLabel.snp.bottom).offset(50)
        }
    }
}
