//
//  NewMessageToastView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/27/24.
//

import UIKit

// 프로필 이미지 사이즈가 40x40이니까, 위아래 패딩 8 준다고 생각하면
// height 56
class NewMessageToastView: BaseView {
    
    let fakeButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
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
        view.textColor = .white
        view.setAppFont(.caption)
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.text = "저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?"
        view.textColor = .white
        view.setAppFont(.body)
        return view
    }()
    
    let chevronImageView = {
        let view = UIImageView()
        view.image = .chevronDown.withTintColor(.white)
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, nameLabel, contentLabel, chevronImageView, fakeButton].forEach { item in
            self.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        fakeButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(self).inset(8)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(self).inset(12)
            make.width.equalTo(chevronImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(nameLabel)
        }
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    func setUpView(_ sender: ChannelChattingInfoModel) {
        self.isHidden = false
        
        // 프로필 이미지
        profileImageView.loadImage(
            endURLString: sender.userImage ?? "",
            size: CGSize(width: 40, height: 40),
            placeholder: .profileNoPhotoA
        )
        
        // 프로필 이름
        nameLabel.text = sender.userName
        nameLabel.setAppFont(.caption)
        
        // 채팅 내용
        contentLabel.text = sender.content
        contentLabel.setAppFont(.body)
    }
}
