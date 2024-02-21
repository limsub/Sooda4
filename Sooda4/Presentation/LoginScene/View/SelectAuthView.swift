//
//  SelectAuthView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import SnapKit

class SelectAuthView: BaseView {
    
    // 소셜 로그인 버튼이 이미지로 저장되어 있어서 여긴 오토레이아웃 따로 안잡는다
    // 버튼 width로 관리
    
    
    let appleLoginButton = UIButton()
    let kakaoLoginButton = UIButton()
    let emailLoginButton = UIButton()
    
    let signUpButton = UIButton()
    
    override func setConfigure() {
        super.setConfigure()
        
        [appleLoginButton, kakaoLoginButton, emailLoginButton, signUpButton].forEach { item in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(self).inset(42)
            make.centerX.equalTo(self)
            make.width.equalTo(323)
            make.height.equalTo(44)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.centerX.equalTo(self)
            make.width.equalTo(323)
            make.height.equalTo(44)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            make.centerX.equalTo(self)
            make.width.equalTo(323)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            make.centerX.equalTo(self)
            make.width.equalTo(323)
            make.height.equalTo(20)
        }
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = UIColor.appColor(.background_primary)
        
        appleLoginButton.setBackgroundImage(UIImage(named: "loginButton_Apple ID Login"), for: .normal)
        kakaoLoginButton.setBackgroundImage(UIImage(named: "loginButton_Kakao Login"), for: .normal)
        emailLoginButton.setBackgroundImage(UIImage(named: "new_email_button"), for: .normal)
        
        signUpButton.setTitle("또는 새롭게 회원가입 하기", for: .normal)
        signUpButton.makeEmailSignUpButton(.title2, for: .normal)
        

    }
    
    
}
