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
            make.trailing.equalTo(contentView).inset(16).priority(1000)
            make.centerY.equalTo(contentView).priority(1000)
            make.height.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(hashtagImageView.snp.trailing).offset(16)
            make.trailing.equalTo(unreadCountLabel.snp.leading).offset(-16).priority(500)
            make.centerY.equalTo(contentView)
        }
    }
    
    func designCell(_ text: String, count: Int) {
        titleLabel.setText(text)
        unreadCountLabel.setText(count)
        
        switch count {
        case 1...9:
            unreadCountLabel.snp.makeConstraints { make in
                make.width.equalTo(19)
            }
        case 10...99:
            unreadCountLabel.snp.makeConstraints { make in
                make.width.equalTo(24)
            }
        case 100...999:
            unreadCountLabel.snp.makeConstraints { make in
                make.width.equalTo(29)
            }
        default:
            unreadCountLabel.snp.makeConstraints { make in
                make.width.equalTo(0)
            }
        }
        
        // count에 따라
        if count > 0 {
            hashtagImageView.update(true)
            titleLabel.update(true)
            unreadCountLabel.isHidden = false
        } else {
            hashtagImageView.update(false)
            titleLabel.update(false)
            unreadCountLabel.isHidden = true
        }
    }
    
    // 채널 탐색에서 사용하는 경우 -> 무조건 다 진하게
    func designWithBold(_ text: String) {
        titleLabel.setText(text)
        
        hashtagImageView.update(true)
        titleLabel.update(true)
        unreadCountLabel.isHidden = true
    }
    
    
}

