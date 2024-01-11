//
//  WorkSpaceListCustomButton.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import UIKit

// 객체는 UIView로 만들고 투명한 버튼 올리기
class WorkSpaceListCustomButton: BaseView {
    
    // 1. 이미지뷰
    // 2. 레이블
    // 3. 투명 버튼
    
    let sImageView = UIImageView()
    let sLabel = {
        // 피그마 상에는 이상한 폰트로 되어있음. 일단 색상만 맞추자
        let view = UILabel()
        view.setAppFont(.body)
        view.textColor = UIColor.appColor(.text_secondary)
        return view
    }()
    let sButton =  {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    
    convenience init(text: String, imageName: String) {
        self.init()
        
        sImageView.image = UIImage(named: imageName)
        sLabel.text = text
        sLabel.setAppFont(.body)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        [sImageView, sLabel, sButton].forEach { item  in
            self.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
        sImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalTo(self).inset(16)
            make.centerY.equalTo(self)
        }
        
        sLabel.snp.makeConstraints { make in
            make.leading.equalTo(sImageView.snp.trailing).offset(16)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        sButton.snp.makeConstraints { make in
            make.size.equalTo(self)
        }

    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = UIColor.appColor(.brand_white)
    }
    
}
