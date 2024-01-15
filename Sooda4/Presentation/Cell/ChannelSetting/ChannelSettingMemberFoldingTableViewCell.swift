//
//  ChannelSettingMemberFoldingTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

// width : screen 동일. height : 56
class ChannelSettingMemberFoldingTableViewCell: BaseTableViewCell {
    
    let memberCountLabel = {
        let view = UILabel()
        view.text = "멤버 (14)"
        view.setAppFont(.title2)
        return view
    }()
    
    let chevronImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "chevron_down")
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [memberCountLabel, chevronImageView].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        memberCountLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(13)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
        }
    }
    
    func designCell(count: Int) {
        memberCountLabel.text = "멤버 (\(count))"
        memberCountLabel.setAppFont(.title2)
    }
}
