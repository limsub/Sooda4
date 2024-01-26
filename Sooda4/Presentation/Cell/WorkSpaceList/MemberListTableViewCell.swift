//
//  MemberListTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import UIKit

// 셀 height 60
class MemberListTableViewCell: BaseTableViewCell {
    
    let profileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "profile_No Photo A")
        return view
    }()
    
    let nameLabel = {
        let view = UILabel()
        view.setAppFont(.bodyBold)
        view.text = "Brooklyn Simmons"
        view.textColor = UIColor.appColor(.text_primary)
        return view
    }()
    
    let emailLabel = {
        let view = UILabel()
        view.setAppFont(.body)
        view.text = "dolores.chambers@naver.com"
        view.textColor = UIColor.appColor(.text_secondary)
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, nameLabel, emailLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(8)
            make.leading.equalTo(contentView).inset(14)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(12)
            make.height.equalTo(18)
            make.leading.equalTo(profileImageView.snp.trailing).offset(11)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(18)
        }
    }
    
    override func setting() {
        super.setting()
        
        contentView.backgroundColor = UIColor.appColor(.background_primary)
    }
    
    func designCell(_ model: WorkSpaceUserInfo) {
        // 1. 이미지
        profileImageView.loadImage(
            endURLString: model.profileImage ?? "",
            size: CGSize(width: 40, height: 40),
            placeholder: .profileNoPhotoA
        )
        
        // 2. 이름
        nameLabel.text = model.nickname
        nameLabel.setAppFont(.bodyBold)
        
        // 3. 이메일
        emailLabel.text = model.email
        emailLabel.setAppFont(.body)
    }
}
