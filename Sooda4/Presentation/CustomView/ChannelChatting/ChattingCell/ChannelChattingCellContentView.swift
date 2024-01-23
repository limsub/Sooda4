//
//  ChannelChattingCellContentView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/23/24.
//

import UIKit

class ChannelChattingCellContentView: BaseView {
    
    
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
    
    
    var sampleView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    var fileImageViews = Array(repeating: UIImageView(), count: 5)
    
    override func setConfigure() {
        super.setConfigure()
        
        // 디폴트 : 모두 있는 경우
        [nameLabel, contentLabel, contentBackView, sampleView].forEach { item in
            self.addSubview(item)
        }
        
        
        
        fileImageViews.forEach { item in
            self.addSubview(item)
        }
    }
    
    // 뷰의 width
    // 1. 기본적으로 contentLabel의 width와 동일
    // 2. 만약 이미지뷰가 있으면, 무조건 이미지뷰의 width
    
    
    override func setConstraints() {
        super.setConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        // 내용이 없으면 hidden 처리됨 -> 어떻게 할건지 고민
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(13)
            make.leading.equalToSuperview().inset(8)
            make.width.lessThanOrEqualTo(228) // 244 - 16
        }
        contentBackView.snp.makeConstraints { make in
            make.edges.equalTo(contentLabel).inset(-8)
//            make.bottom.equalToSuperview()
//            make.horizontalEdges.equalToSuperview()
        }
        
        
        
        sampleView.snp.makeConstraints { make in
            make.top.equalTo(contentBackView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(self)  // 이미지가 있으면 무조건 얘랑 같아짐
            // 임의의 사이즈
            make.height.equalTo(50)
            make.width.equalTo(244)
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    func designView(_ sender: ChattingInfoModel) {

        self.nameLabel.text = sender.userName
        self.contentLabel.text = sender.content
        
        
        if sender.content!.isEmpty {
            // 내용이 없는 경우 (이미지가 위로 붙음)
            contentLabel.isHidden = true
            contentBackView.isHidden = true
            sampleView.isHidden = false
            
            contentLabel.snp.removeConstraints()
            contentBackView.snp.removeConstraints()
            
            sampleView.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.horizontalEdges.equalTo(self)
                make.bottom.equalTo(self)
                make.height.equalTo(50)
                make.width.equalTo(244)
            }
        }
        
        else if sender.files.isEmpty {
            // 이미지가 없는 경우
            contentLabel.isHidden = false
            contentBackView.isHidden = false
            sampleView.isHidden = true
            sampleView.snp.removeConstraints()
            
            contentLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(13)
                make.left.equalTo(self).inset(8)
                make.width.lessThanOrEqualTo(228)
            }
            contentBackView.snp.makeConstraints { make in
                make.edges.equalTo(contentLabel).inset(-8)
                // 두개 추가 (이미지가 없기 때문)
                make.bottom.equalTo(self)
                make.horizontalEdges.equalTo(self)
            }
        }
        
        else {
            // 둘 다 없거나 둘 다 있거나 -> 둘 다 없는건 불가 (전송이 안됨)
            // 즉, 둘 다 있다고 가정.
        }
        
        // 이거 없어도 되긴 한데, 일단 혹시 모르니까
        setNeedsLayout()
        layoutIfNeeded()
    }
}
