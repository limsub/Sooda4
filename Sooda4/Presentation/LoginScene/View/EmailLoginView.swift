//
//  LoginView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import SnapKit

class EmailLoginView: BaseView {
    
    let emailTitleLabel = SignUpTextFieldTitleLabel("이메일")
    let pwTitleLabel = SignUpTextFieldTitleLabel("비밀번호")
    
    let emailTextField = SignUpTextField("이메일을 입력하세요")
    let pwTextField = SignUpTextField("비밀번호를 입력하세요")
    
    let completeButton = SignUpActiveButton("로그인")
    
    override func setConfigure() {
        super.setConfigure()
        
        [emailTitleLabel, pwTitleLabel, emailTextField, pwTextField, completeButton].forEach { item  in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let h = 44
        let p = 24
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(p)
            make.height.equalTo(p)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(h)
        }
        
        pwTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(p)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(p)
        }
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(h)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(p)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(h)
        }
    }
    
    
}
