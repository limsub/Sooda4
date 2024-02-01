//
//  ChannelSettingMemberCollectionViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

// 일단, 셀 크기 76 x 91 . inset zero
class ChannelSettingMemberCollectionViewCell: BaseCollectionViewCell {
        
    // 44 x 44
    let profileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "profile_No Photo A")
        
        return view
    }()
    
    // height : 18 (한줄) 36 (두줄)
    // -> 36으로 고정
    let nameLabel = {
        let view = UILabel()
        view.text = "Sam"
        view.setAppFont(.body)
        view.numberOfLines = 2
        view.textAlignment = .center
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, nameLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(3.5)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(profileImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.centerX.equalTo(contentView)
        }
    }
    
    func designCell(imageUrl: String?, name: String) {
        // * 이미지 넣어주기
        profileImageView.loadImage(
            endURLString: imageUrl ?? "",
            size: CGSize(width: 40, height: 40),
            placeholder: .profileNoPhotoA
        )
        
        nameLabel.text = name
        nameLabel.setAppFont(.body)
        nameLabel.textAlignment = .center
        
    }
}
