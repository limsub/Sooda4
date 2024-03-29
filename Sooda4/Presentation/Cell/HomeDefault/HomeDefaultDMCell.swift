//
//  HomeDefaultDMCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import UIKit

class HomeDefaultDMTableViewCell: BaseTableViewCell {
    
    // 24 x 24
    let profileImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profile_No Photo A")
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    let titleLabel = HomeDefaultCellTitleLabel()
    let unreadCountLabel = HomeDefaultUnreadCountLabel()
    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, titleLabel, unreadCountLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalTo(contentView).inset(14)
            make.centerY.equalTo(contentView)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(16).priority(1000)
            make.centerY.equalTo(contentView)
            make.height.equalTo(18)
//            make.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(11)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(unreadCountLabel.snp.leading).offset(-16).priority(500)
        }
    }
    
    func designCell(image: String?, text: String, count: Int) {
        
        profileImageView.loadImage(
            endURLString: image ?? "",
            size: CGSize(width: 30, height: 30),
            placeholder: .profileNoPhotoA
        )
        
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
        
        if count > 0 {
            titleLabel.update(true)
            unreadCountLabel.isHidden = false
        } else {
            titleLabel.update(false)
            unreadCountLabel.isHidden = true
        }
    }
}

