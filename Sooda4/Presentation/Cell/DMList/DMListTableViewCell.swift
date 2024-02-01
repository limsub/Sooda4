//
//  DMListTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import UIKit

// cell height autodimension
class DMListTableViewCell: BaseTableViewCell {
    
    // 34 x 34
    let profileImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profile_No Photo B")
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    // max 1줄. height 18
    let nameLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.text = "옹골찬 고래밥"
        view.setAppFont(.caption)
        return view
    }()
    
    // max 2줄. height 유동적
    let contentLabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.text = [
            "오늘 정말 고생 많으셨습니다~!!",
            "오늘 정말 고생 많으셨습니다~!!오늘 정말 고생 많으셨습니다~!!오늘 정말 고생 많으셨습니다~!!오늘 정말 고생 많으셨습니다~!!오늘 정말 고생 많으셨습니다~!!오늘 정말 고생 많으셨습니다~!!"
        ].randomElement()
        view.setAppFont(.caption2)
        view.textColor = UIColor.appColor(.text_secondary)
        return view
    }()
    
    
    let dateLabel = {
        let view = UILabel()
        view.text = [
            "PM 11:23",
            "2024년 1월 20일"
        ].randomElement()
        view.setAppFont(.caption2)
        view.textColor = UIColor.appColor(.text_secondary)
        return view
    }()
    
    
    let unreadCountLabel = {
        let view = HomeDefaultUnreadCountLabel()
        view.setText([1, 21, 99, 101].randomElement()!)
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, nameLabel, contentLabel, dateLabel, unreadCountLabel].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.leading.equalTo(contentView).inset(16)
            make.size.equalTo(34)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.trailing.equalTo(contentView).inset(24).priority(1000)
            make.height.equalTo(18)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.trailing.equalTo(dateLabel).priority(1000)
            make.width.lessThanOrEqualTo(30)
            make.height.equalTo(18)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-4)
            make.height.equalTo(18)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(unreadCountLabel.snp.leading).offset(-4)
            make.bottom.equalTo(contentView).inset(6)
        }
    }
    
}
