//
//  InitialWorkSpaceView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import SnapKit

class InitialWorkSpaceView: BaseView {
    
    // MARK: - 임시
    let tempLabel = UILabel()
    let b1 = UIButton()
    let b2 = UIButton()
    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
        
        tempLabel.text = "이니셜 워크스페이스 뷰"
        tempLabel.backgroundColor = .yellow
        
        b1.setTitle("x 버튼", for: .normal)
        b2.setTitle("워크스페이스 생성", for: .normal)
        
        
        self.addSubview(tempLabel)
        self.addSubview(b1)
        self.addSubview(b2)
        tempLabel.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(self)
        }
        b1.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(tempLabel.snp.bottom).offset(50)
            make.leading.equalTo(self).inset(40)
        }
        b2.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(b1)
            make.leading.equalTo(b1.snp.trailing).offset(40)
        }
    }
}
