//
//  WorkSpaceListTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import UIKit

// 셀 height 72. 내부 색칠 뷰 height 60. -> 상하 6 패딩
// 좌우 8 패딩

class WorkSpaceListTableViewCell: BaseTableViewCell {
    
    
    let backView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.appColor(.brand_gray)
        return view
    }()
    
    let workSpaceImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "profile_No Photo A")
        return view
    }()
    
    let workSpaceTitleLabel = {
        let view = UILabel()
        view.text = "영등포 새싹이들 모임"
        view.setAppFont(.bodyBold)
        view.textColor = UIColor.appColor(.text_primary)
        return view
    }()
    
    let workSpaceCreatedDateLabel = {
        let view = UILabel()
        view.text = "23. 11. 01"
        view.setAppFont(.body)
        view.textColor = UIColor.appColor(.text_secondary)
        return view
    }()
    
    let menuButton = {  // 현재 속한 워크스페이스인 경우만 메뉴버튼
        let view = UIButton()
        view.setImage(UIImage(named: "icon_three dots_black"), for: .normal)
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [backView, workSpaceImageView, workSpaceTitleLabel, workSpaceCreatedDateLabel, menuButton].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.verticalEdges.equalTo(contentView).inset(6)
        }
        
        workSpaceImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(14) // -> 72 - 28 = 44
            make.width.equalTo(workSpaceImageView.snp.height)
            make.leading.equalTo(contentView).inset(16)
        }
        
        workSpaceTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.equalTo(contentView).inset(18)
            make.leading.equalTo(workSpaceImageView.snp.trailing).offset(8)
        }
        
        workSpaceCreatedDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(workSpaceTitleLabel)
            make.top.equalTo(workSpaceTitleLabel.snp.bottom)
            make.height.equalTo(18)
        }
        
        menuButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(18)
        }
        
    }
    
    
    
    
    
    func designCell() {
        // 배경 색칠 or not
        
        // 이미지
        
        // 타이틀
        
        // 날짜
    }
}
