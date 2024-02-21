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
    
    let introduceLabel = {
        let view = UILabel()
        view.setAppFont(.title1)
        view.numberOfLines = 2
        view.textAlignment = .center
        return view
    }()
    let iconImageView = UIImageView()
    let nextButton = UIButton()
    
    override func setting() {
        super.setting()
        
        introduceLabel.text = "자유롭고 유연한 업무 소통의 시작,\n수다와 함께하세요"
        introduceLabel.setAppFont(.title1)
        introduceLabel.textAlignment = .center

        iconImageView.image = .mainIcon
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .blue
        
        self.addSubview(introduceLabel)
        self.addSubview(iconImageView)
        self.addSubview(nextButton)

        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(120)
            make.horizontalEdges.equalTo(self).inset(24)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp.bottom).offset(50)
            make.size.equalTo(368)
            make.centerX.equalTo(self)
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
