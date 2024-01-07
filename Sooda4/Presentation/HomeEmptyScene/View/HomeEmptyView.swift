//
//  HomeEmptyView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit

class HomeEmptyView: BaseView {
    
    // MARK: - 임시
    let tempLabel = UILabel()
    let b1 = UIButton()

    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
        
        tempLabel.text = "워크스페이스를 찾을 수 업서요"
        tempLabel.backgroundColor = .yellow
        
        b1.setTitle("워크스페이스 생성", for: .normal)
        b1.backgroundColor = .black
        
        
        self.addSubview(tempLabel)
        self.addSubview(b1)

        tempLabel.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(self)
        }
        b1.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.top.equalTo(tempLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).inset(40)
        }

    }
    
    
}
