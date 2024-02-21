//
//  OnboardingView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import SnapKit

class OnboardingView: BaseView {
    
    // MARK: - 임시
    let tempLabel = UILabel()
    
    let iconImageView = UIImageView()
    let nextButton = UIButton()
    
    override func setting() {
        super.setting()
        
//        backgroundColor = .blue
        
//        tempLabel.text = "온보딩 뷰"
//        tempLabel.backgroundColor = .yellow
        
        iconImageView.image = .mainIcon
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .blue
        
//        self.addSubview(tempLabel)
        self.addSubview(iconImageView)
        self.addSubview(nextButton)
//        tempLabel.snp.makeConstraints { make in
//            make.size.equalTo(200)
//            make.center.equalTo(self)
//        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(368)
            make.center.equalTo(self)
        }
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(self)
            make.top.equalTo(iconImageView.snp.bottom).offset(50)
        }
        
//        tempLabel.setAppFont(.title2)
//        tempLabel.textColor = .purple
    }
    
}
