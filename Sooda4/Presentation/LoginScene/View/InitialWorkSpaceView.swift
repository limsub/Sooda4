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
    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
        
        tempLabel.text = "이니셜 워크스페이스 뷰"
        tempLabel.backgroundColor = .yellow
        
        self.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(self)
        }
    }
}
