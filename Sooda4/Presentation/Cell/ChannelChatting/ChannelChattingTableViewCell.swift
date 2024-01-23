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
    
    // nameLabel + contentLabel(+ contentBackView) + fileImageView -> customView로 합치기
    var chattingContentView = ChannelChattingCellContentView2()

    
    let dateLabel = {
        let view = UILabel()
        view.text = "08:16 오전"
        view.setAppFont(.caption2)   // * 텍스트 이상함. 피그마 상에는 caption 2
        return view
    }()
    
    
    override func prepareForReuse() {
        
//        chattingContentView = ChannelChattingCellContentView()
        chattingContentView.contentLabel.isHidden = false
        chattingContentView.contentBackView.isHidden = false
        chattingContentView.sampleView.isHidden = false
    }

    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, chattingContentView, dateLabel].forEach { item  in
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
        
//        nameLabel.snp.makeConstraints { make in
//            make.top.equalTo(profileImageView)
//            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
//        }
//        
//        
//        contentLabel.snp.makeConstraints { make in
//            make.top.equalTo(nameLabel.snp.bottom).offset(13)
//            make.leading.equalTo(nameLabel).inset(8)
//            make.width.lessThanOrEqualTo(244)
//        }
//        
//        
//        contentBackView.snp.makeConstraints { make in
//            make.edges.equalTo(contentLabel).inset(-8)
//            make.bottom.equalTo(contentView).inset(6)
//        }
        
        chattingContentView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.verticalEdges.equalTo(contentView).inset(6)
        }
        
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chattingContentView)
            make.leading.equalTo(chattingContentView.snp.trailing).offset(8)
        }
    }
    
    func designCell(_ sender: ChattingInfoModel) {
        
        self.chattingContentView.designView(sender)

        chattingContentView.backgroundColor = .yellow
        
        self.dateLabel.text = sender.createdAt.toString(of: .timeAMPM)
    }
}
