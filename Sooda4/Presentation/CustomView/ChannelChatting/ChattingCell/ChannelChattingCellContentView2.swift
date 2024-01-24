//
//  ChannelChattingCellContentView2.swift
//  Sooda4
//
//  Created by 임승섭 on 1/23/24.
//


// 이미지만 있는거 굿. 텍스트만 있는거 굿.
// 근데 둘 다 있는게 안먹음....
// 제약조건 참조타입으로 햅괴.


import UIKit
import SnapKit

class ChannelChattingCellContentView2: BaseView {
    
    
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
        let view = ChannelChattingCellContentImageSetView()
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        // 디폴트 : 모두 있는 경우
        [nameLabel, contentLabel, contentBackView, sampleView].forEach { item in
            self.addSubview(item)
        }
        
    }
    
    // 뷰의 width
    // 1. 기본적으로 contentLabel의 width와 동일
    // 2. 만약 이미지뷰가 있으면, 무조건 이미지뷰의 width
    
    
    
    
    
    var contentTopName: Constraint? = nil
    
    var sampleTopName: Constraint? = nil
    var sampleTopContent: Constraint? = nil
    
    var contentBottomSelf: Constraint? = nil
    var sampleBottomSelf: Constraint? = nil
    
    var contentWidthSelf: Constraint? = nil
    var sampleWidthSelf: Constraint? = nil
    
    
    // 1. 둘 다 있다   -> a / d / a / d / a / d / a
    // 2. 텍스트만 있다 -> a / d / d / a / d / a / d
    // 3. 이미지만 있다 -> d / a / d / d / a / d / a
    
    
    
    var sampleViewSingleLine: Constraint? = nil // 2, 3
    var sampleViewDoubleLine: Constraint? = nil // 1, 4, 5
    
    

    
    override func setConstraints() {
        super.setConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        

        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(8)
            make.width.lessThanOrEqualTo(228)
            
            self.contentTopName = make.top.equalTo(nameLabel.snp.bottom).offset(13).constraint
            self.contentBottomSelf =  make.bottom.equalTo(self).inset(8).constraint
            self.contentWidthSelf = make.width.equalTo(self).inset(8).constraint
        }
        contentBackView.snp.makeConstraints { make in
            make.edges.equalTo(contentLabel).inset(-8)
        }
        
        
        sampleView.snp.makeConstraints { make in
            
            make.width.equalTo(244)
            
            self.sampleViewSingleLine = make.height.equalTo(80).constraint
            self.sampleViewDoubleLine = make.height.equalTo(162).constraint
            
            self.sampleTopName = make.top.equalTo(nameLabel.snp.bottom).offset(5).constraint
            self.sampleTopContent = make.top.equalTo(contentBackView.snp.bottom).offset(5).constraint
            self.sampleBottomSelf = make.bottom.equalTo(self).constraint
            self.sampleWidthSelf =  make.horizontalEdges.equalTo(self).constraint
        }
        
        
        contentTopName?.activate()
        sampleTopName?.deactivate()
        sampleTopContent?.activate()
        contentBottomSelf?.deactivate()
        sampleBottomSelf?.activate()
        
        contentWidthSelf?.deactivate()
        sampleWidthSelf?.activate()
        
        sampleViewSingleLine?.deactivate()
        sampleViewDoubleLine?.activate()
    }
    
    
    
    func designView(_ sender: ChattingInfoModel) {
        
        backgroundColor = .clear
        
        func singleLine(_ cnt: Int) -> Bool {
            if cnt == 1 || cnt > 3 { return false }
            else { return true }
        }
        
        self.nameLabel.text = sender.userName
        self.contentLabel.text = sender.content
        self.sampleView.updateView(sender.files)
        
        self.nameLabel.setAppFont(.caption)
        self.contentLabel.setAppFont(.body)
        
        
        
        // 텍스트만 있다 -> a / d / d / a / d  / a / d
        if sender.files.isEmpty {
            contentLabel.isHidden = false
            contentBackView.isHidden = false
            sampleView.isHidden = true
            
            contentTopName?.activate()
            sampleTopName?.deactivate()
            sampleTopContent?.deactivate()
            contentBottomSelf?.activate()
            sampleBottomSelf?.deactivate()
            contentWidthSelf?.activate()
            sampleWidthSelf?.deactivate()
        }
        
        // 이미지만 있다 -> d / a / d / d / a / d / a
        else if sender.content!.isEmpty {
            contentLabel.isHidden = true
            contentBackView.isHidden = true
            sampleView.isHidden = false
            
            contentTopName?.deactivate()
            sampleTopName?.activate()
            sampleTopContent?.deactivate()
            contentBottomSelf?.deactivate()
            sampleBottomSelf?.activate()
            
            contentWidthSelf?.deactivate()
            sampleWidthSelf?.activate()
            
            
            if singleLine(sender.files.count) {
                sampleViewSingleLine?.activate()
                sampleViewDoubleLine?.deactivate()
            } else {
                sampleViewSingleLine?.deactivate()
                sampleViewDoubleLine?.activate()
            }
        }
        
        // 둘 다 있다   -> a / d / a / d / a / d / a
        else {
            contentLabel.isHidden = false
            contentBackView.isHidden = false
            sampleView.isHidden = false
            
            contentTopName?.activate()
            sampleTopName?.deactivate()
            sampleTopContent?.activate()
            contentBottomSelf?.deactivate()
            sampleBottomSelf?.activate()
            
            contentWidthSelf?.deactivate()
            sampleWidthSelf?.activate()
            
            if singleLine(sender.files.count) {
                sampleViewSingleLine?.activate()
                sampleViewDoubleLine?.deactivate()
            } else {
                sampleViewSingleLine?.deactivate()
                sampleViewDoubleLine?.activate()
            }
        }
        
        

        // 이거 없어도 되긴 한데, 일단 혹시 모르니까
        setNeedsLayout()
        layoutIfNeeded()
    }
    

}

