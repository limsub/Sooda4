//
//  ChannelChattingTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/18/24.
//

import UIKit

class ChannelChattingTableViewCell: BaseTableViewCell {
    
    let profileImageView = {
        let view = UIImageView()
        view.image = .profileNoPhotoA
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let nameLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.text = "옹골찬 고래밥"
        view.setAppFont(.caption)
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?"
        view.setAppFont(.body)
        return view
    }()
    
    let contentBackView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.appColor(.brand_inactive).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.text = "08:16 오전"
        view.setAppFont(.caption2)   // * 텍스트 이상함. 피그마 상에는 caption 2
        return view
    }()
    
    // 얜 일단 패스
    let fileImageView = {
        let view = UIImageView()
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, nameLabel, contentLabel, contentBackView, dateLabel, fileImageView].forEach { item  in
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
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(13)
            make.leading.equalTo(nameLabel).inset(8)
            make.width.lessThanOrEqualTo(244)
        }
        
        
        contentBackView.snp.makeConstraints { make in
            make.edges.equalTo(contentLabel).inset(-8)
            make.bottom.equalTo(contentView).inset(6)
        }
        
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentBackView)
            make.leading.equalTo(contentBackView.snp.trailing).offset(8)
        }
    }
    
    func designCell(_ sender: ChattingInfoModel) {
        
//        self.profileImageView = sender.userImage
        self.nameLabel.text = sender.userName
        self.contentLabel.text = sender.content
        self.dateLabel.text = sender.createdAt.toString(of: .timeAMPM)
    }
}
