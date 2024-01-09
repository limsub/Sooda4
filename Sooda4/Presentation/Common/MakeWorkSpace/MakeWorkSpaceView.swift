//
//  MakeWorkSpaceView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit

class MakeWorkSpaceView: BaseView {
    
    let messageImageView = {
        let view = UIImageView()
        view.backgroundColor = .green
        return view
    }()
    
    let nameTitleLabel = SignUpTextFieldTitleLabel("워크스페이스 이름")
    let descriptionTitleLabel = SignUpTextFieldTitleLabel("워크스페이스 설명")
    
    let nameTextField = SignUpTextField("워크스페이스 이름을 입력하세요 (필수)")
    let descriptionTextField = SignUpTextField("워크스페이스를 설명하세요 (옵션)")
    
    let completeButton = SignUpActiveButton("완료")
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [messageImageView, nameTitleLabel, descriptionTitleLabel, nameTextField, descriptionTextField, completeButton].forEach { item  in
            addSubview(item)
        }
    }
    
    
    override func setConstraints() {
        super.setConstraints()
        
        let h = 44
        let p = 24
        
        messageImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.size.equalTo(70)
            make.top.equalTo(self.safeAreaLayoutGuide).inset(p)
        }
        
        nameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(messageImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(p)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(h)
        }
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(p)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(p)
        }
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(h)
        }
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(h)
            make.horizontalEdges.equalTo(self).inset(p)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(24)
        }
        
    }
}
