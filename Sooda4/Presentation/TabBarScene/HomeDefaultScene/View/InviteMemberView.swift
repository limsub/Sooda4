//
//  InviteMemberView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit


class InviteMemberView: BaseView {
    
    let emailTitleLabel = SignUpTextFieldTitleLabel("이메일")
    let emailTextField = SignUpTextField("초대하려는 팀원의 이메일을 입력하세요")
    let completeButton = SignUpActiveButton("초대 보내기")
    
    override func setConfigure() {
        super.setConfigure()
        
        [emailTitleLabel, emailTextField, completeButton].forEach { item in
            self.addSubview(item)
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
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(p)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(h)
        }
    }
    
}
