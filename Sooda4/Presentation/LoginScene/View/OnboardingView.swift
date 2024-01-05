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
    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
        
        tempLabel.text = "온보딩 뷰"
        tempLabel.backgroundColor = .yellow
        
        self.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(self)
        }
    }
    
}
