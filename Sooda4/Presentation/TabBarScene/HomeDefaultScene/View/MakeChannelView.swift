//
//  MakeChannelView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit

class MakeChannelView: BaseView {
    
    let nameTitleLabel = SignUpTextFieldTitleLabel("채널 이름")
    let descriptionTitleLabel = SignUpTextFieldTitleLabel("채널 설명")
    
    let nameTextField = SignUpTextField("채널 이름을 입력하세요 (필수)")
    let descriptionTextField = SignUpTextField("채널을 설몀하세요 (옵션)")
    
    let completeButton = SignUpActiveButton("생성")
    
    override func setConfigure() {
        super.setConfigure()
        
        [nameTitleLabel, descriptionTitleLabel, nameTextField, descriptionTextField, completeButton].forEach { item in
            self.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConfigure()
        
        let h = 44
        let p = 24
        
        nameTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(p)
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
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(p)
            make.horizontalEdges.equalTo(self).inset(p)
            make.height.equalTo(h)
        }
    }
    
}
