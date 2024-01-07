//
//  SignUpView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import SnapKit

class SignUpView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let emailTitleLabel = SignUpTextFieldTitleLabel("이메일")
    let nicknameTitleLabel = SignUpTextFieldTitleLabel("닉네임")
    let phoneNumTitleLabel = SignUpTextFieldTitleLabel("연락처")
    let pwTitleLabel = SignUpTextFieldTitleLabel("비밀번호")
    let checkPwTitleLabel = SignUpTextFieldTitleLabel("비밀번호 확인")
    
    let emailTextField = SignUpTextField("이메일을 입력하세요")
    let nicknameTextField = SignUpTextField("닉네임을 입력하세요")
    let phoneNumTextField = SignUpTextField("전화번호를 입력하세요")
    let pwTextField = SignUpTextField("비밀번호를 입력하세요")
    let checkPwTextField = SignUpTextField("비밀번호를 한 번 더 입력하세요")
    
    let checkEmailValidButton = SignUpActiveButton("중복 확인")
    let completeButton = SignUpActiveButton("가입하기")
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [emailTitleLabel, nicknameTitleLabel, phoneNumTitleLabel, pwTitleLabel, checkPwTitleLabel, emailTextField, nicknameTextField, phoneNumTextField, pwTextField, checkPwTextField, checkEmailValidButton, completeButton].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let h = 44
        let p = 24
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(p)
            make.height.equalTo(p)
        }
        checkEmailValidButton.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(contentView).inset(p)
            make.width.equalTo(100)
            make.height.equalTo(h)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).inset(p)
            make.trailing.equalTo(checkEmailValidButton.snp.leading).offset(-12)
            make.height.equalTo(h)
        }
        
        nicknameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(p)
            make.horizontalEdges.equalTo(contentView).inset(p)
            make.height.equalTo(p)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(p)
            make.height.equalTo(h)
        }
        
        phoneNumTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(p)
            make.horizontalEdges.equalTo(contentView).inset(p)
            make.height.equalTo(p)
        }
        phoneNumTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(p)
            make.height.equalTo(h)
        }
        
        pwTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumTextField.snp.bottom).offset(p)
            make.horizontalEdges.equalTo(contentView).inset(p)
            make.height.equalTo(p)
        }
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(p)
            make.height.equalTo(h)
        }
                
        checkPwTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(p)
            make.horizontalEdges.equalTo(p)
            make.height.equalTo(p)
        }
        checkPwTextField.snp.makeConstraints { make in
            make.top.equalTo(checkPwTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(p)
            make.height.equalTo(h)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(p)
            make.horizontalEdges.equalTo(contentView).inset(p)
            make.height.equalTo(h)
            make.bottom.equalTo(contentView).inset(24)
        }
    }
}
