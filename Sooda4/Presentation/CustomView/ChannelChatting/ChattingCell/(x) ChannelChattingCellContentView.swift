////
////  ChannelChattingCellContentView.swift
////  Sooda4
////
////  Created by 임승섭 on 1/23/24.
////
//
//import UIKit
//
//class ChannelChattingCellContentView: BaseView {
//    
//    
//    let nameLabel = {
//        let view = UILabel()
//        view.numberOfLines = 1
//        view.text = "옹골찬 고래밥"
//        view.setAppFont(.caption)
//        return view
//    }()
//    
//    let contentLabel = {
//        let view = UILabel()
//        view.numberOfLines = 0
//        view.text = "저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?"
//        view.setAppFont(.body)
//        return view
//    }()
//    
//    let contentBackView = {
//        let view = UIView()
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 8
//        view.layer.borderColor = UIColor.appColor(.brand_inactive).cgColor
//        view.layer.borderWidth = 1
//        return view
//    }()
//    
//    
//    var sampleView = {
//        let view = ChannelChattingCellContentImageSetView()
//        view.backgroundColor = .red
//        return view
//    }()
//    
//    
//    override func setConfigure() {
//        super.setConfigure()
//        
//        // 디폴트 : 모두 있는 경우
//        [nameLabel, contentLabel, contentBackView, sampleView].forEach { item in
//            self.addSubview(item)
//        }
//        
//    }
//    
//    // 뷰의 width
//    // 1. 기본적으로 contentLabel의 width와 동일
//    // 2. 만약 이미지뷰가 있으면, 무조건 이미지뷰의 width
//    
//    override func setConstraints() {
//        super.setConstraints()
//        
//        nameLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//        }
//        
//
//        contentLabel.snp.makeConstraints { make in
//            make.top.equalTo(nameLabel.snp.bottom).offset(13)
//            make.leading.equalTo(self).inset(8)
//            make.width.lessThanOrEqualTo(228)
//        }
//        contentBackView.snp.makeConstraints { make in
//            make.edges.equalTo(contentLabel).inset(-8)
//        }
//        sampleView.snp.makeConstraints { make in
//            make.top.equalTo(contentBackView.snp.bottom).offset(5)
//            make.bottom.equalTo(self)
//            make.height.equalTo(162)
//            make.width.equalTo(244)
//            make.horizontalEdges.equalTo(self)  // 얘 너비에 맞처진다.
//        }
//        
//    }
//    
//    
//    
//    func designView(_ sender: ChattingInfoModel) {
//        
////        print("--- designView sender : ", sender)
//        self.nameLabel.text = sender.userName
//        self.contentLabel.text = sender.content
//        
//
//        // 내용이 없는 경우, 이미지가 위로 붙어야 한다.
//        if sender.content!.isEmpty {
//            print("내용 없는 친구 : \(sender.createdAt.toString(of: .timeAMPM))")
//            
//            contentLabel.isHidden = true
//            contentBackView.isHidden = true
//            
//            contentLabel.snp.removeConstraints()
//            contentBackView.snp.removeConstraints()
//            
//            sampleView.snp.makeConstraints { make in
//                make.top.equalTo(nameLabel.snp.bottom).offset(5)
//                make.width.equalTo(244)
//                make.horizontalEdges.equalTo(self)
//                make.bottom.equalTo(self)
//                make.height.equalTo(sender.files.count > 3 ? 162 : 80)
//            }
//        }
//        
//        // 이미지가 없는 경우, 내용이 bottom 먹는다
//        else if sender.files.isEmpty {
//            print("이미지 없는 친구 : \(sender.createdAt.toString(of: .timeAMPM))")
//            
//            sampleView.isHidden = true
//            
//            sampleView.snp.removeConstraints()
//            
//            contentLabel.snp.makeConstraints { make in
//                make.top.equalTo(nameLabel.snp.bottom).offset(13)
//                make.leading.equalTo(self).inset(8)
//                make.width.lessThanOrEqualTo(228)
//            }
//            contentBackView.snp.makeConstraints { make in
//                make.edges.equalTo(contentLabel).inset(-8)
//                make.bottom.equalTo(self)
//                make.horizontalEdges.equalTo(self)
//            }
//        }
//        
//        // 둘 다 있을 때
//        else {
//            contentLabel.isHidden = false
//            contentBackView.isHidden = false
//            sampleView.isHidden = false
//            
//            print("둘 다 있는 친구 : \(sender.createdAt.toString(of: .timeAMPM))")
//            
//            
//            contentLabel.snp.makeConstraints { make in
//                make.top.equalTo(nameLabel.snp.bottom).offset(13)
//                make.leading.equalTo(self).inset(8)
//                make.width.lessThanOrEqualTo(228)
//            }
//            contentBackView.snp.makeConstraints { make in
//                make.edges.equalTo(contentLabel).inset(-8)
//            }
//            sampleView.snp.remakeConstraints { make in
//                make.top.equalTo(contentBackView.snp.bottom).offset(5)
//                
//                make.height.equalTo(162)
//                make.width.equalTo(244)
//                make.horizontalEdges.equalTo(self)  // 얘 너비에 맞춰진다.
//                make.bottom.equalTo(self)
//            }
//        }
//
//        // 이거 없어도 되긴 한데, 일단 혹시 모르니까
//        setNeedsLayout()
//        layoutIfNeeded()
//    }
//}
//
