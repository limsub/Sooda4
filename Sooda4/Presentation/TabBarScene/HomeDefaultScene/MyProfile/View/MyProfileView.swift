//
//  MyProfileView.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import UIKit

class MyProfileView: BaseView {
    
    // 0. backView
    let backView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    
    // 1. 프로필 이미지
    let profileImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profile_No Photo A")
        view.clipsToBounds = true
        view.layer.cornerRadius = 75
        return view
    }()
    
    // 2. 코인 이미지 + 레이블 스택뷰
    let coinStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .horizontal
        view.alignment = .center
        return view
    }()
    
    // 2 - 1. 보유 코인 이미지
    let coinImageView = {
        let view = UIImageView()
        view.image = .sample1
        return view
    }()
    
    // 2 - 2. 보유 코인 레이블
    let coinLabel = {
        let view = UILabel()
        view.text = "120"
        return view
    }()
    
    // 3. 프로필 이름 레이블
    let nameLabel = {
        let view = UILabel()
        view.text = "Allen Danis"
        return view
    }()
    
    // 4 - 1. 100 코인 버튼
    let aCoinButton = PurchaseCoinButton(coinType: .a)
    
    // 4 - 2. 500 코인 버튼
    let bCoinButton = PurchaseCoinButton(coinType: .b)
    
    // 4 - 3. 1000 코인 버튼
    let cCoinButton = PurchaseCoinButton(coinType: .c)
    
    
    // setConfigure
    override func setConfigure() {
        super.setConfigure()
        
        [coinImageView, coinLabel].forEach {
            coinStackView.addArrangedSubview($0)
        }
        
        [backView, profileImageView, coinStackView, nameLabel, aCoinButton, bCoinButton, cCoinButton].forEach {
            self.addSubview($0)
        }
    }
    
    // setConstraints
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(443)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalTo(self)
            make.top.equalTo(self.safeAreaLayoutGuide).inset(25)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
            make.centerX.equalTo(self)
            make.height.equalTo(30)
        }
        
        coinImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        coinStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.centerX.equalTo(self)
            make.height.equalTo(30)
        }
        
        
        
        aCoinButton.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).inset(10)
            make.horizontalEdges.equalTo(self).inset(10)
            make.height.equalTo(70)
        }
        
        bCoinButton.snp.makeConstraints { make in
            make.top.equalTo(aCoinButton.snp.bottom)
            make.horizontalEdges.equalTo(self).inset(10)
            make.height.equalTo(70)
        }
        
        cCoinButton.snp.makeConstraints { make in
            make.top.equalTo(bCoinButton.snp.bottom)
            make.horizontalEdges.equalTo(self).inset(10)
            make.height.equalTo(70)
        }
        
    }
    
    
}
