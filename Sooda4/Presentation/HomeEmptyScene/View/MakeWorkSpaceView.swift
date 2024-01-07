//
//  MakeWorkSpaceView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit

class MakeWorkSpaceView: BaseView {
    
    // MARK: - 임시
    let tempLabel = UILabel()
    let b1 = UIButton()
    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
        
        tempLabel.text = "워크스페이스 만들기 뷰"
        tempLabel.backgroundColor = .yellow
        
        b1.setTitle("생성 완료", for: .normal)
        b1.backgroundColor = .brown
        
        
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
