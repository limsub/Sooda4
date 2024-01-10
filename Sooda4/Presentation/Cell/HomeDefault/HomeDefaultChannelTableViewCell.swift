//
//  HomeDefaultChannelTablViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import UIKit

class HomeDefaultChannelTableViewCell: BaseTableViewCell {
    
    let hashtagImageView = HomeDefaultHashtagImageView(frame: .zero)
    let titleLabel = HomeDefaultCellTitleLabel()
    let unreadCountLabel = HomeDefaultUnreadCountLabel()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [hashtagImageView, titleLabel, unreadCountLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        hashtagImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalTo(contentView).inset(16)
            make.centerY.equalTo(contentView)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(17).priority(1000)
            make.centerY.equalTo(contentView).priority(1000)
////            make.width.equalTo(1)
//            make.width.greaterThanOrEqualTo(19)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(hashtagImageView.snp.trailing).offset(16)
            make.trailing.equalTo(unreadCountLabel.snp.leading).offset(-16)
            make.centerY.equalTo(contentView)
        }
    }
    
    func designCell(_ text: String, count: Int) {
        titleLabel.setText(text)
        unreadCountLabel.setText(count)
        
//        if count > 0 {
//            hashtagImageView.update(true)
//            titleLabel.update(true)
//        } else {
//            hashtagImageView.update(false)
//            titleLabel.update(false)
//        }
    }
    
    
}

