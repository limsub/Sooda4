//
//  ChannelChattingSeperatorTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/23/24.
//

import UIKit

class ChannelChattingSeperatorTableViewCell: BaseTableViewCell {
    
    let seperatorLabel = {
        let view = UILabel()
        view.text = "여기까지 읽으셨습니다."
        view.setAppFont(.caption)
        view.textAlignment = .center
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appColor(.brand_inactive).cgColor
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(seperatorLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        seperatorLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(130)
            make.centerX.equalTo(contentView)
            make.verticalEdges.equalTo(contentView)
        }
    }
}
