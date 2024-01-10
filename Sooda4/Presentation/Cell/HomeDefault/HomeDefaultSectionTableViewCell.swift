//
//  HomeDefaultSectionTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import UIKit

// width x 56
class HomeDefaultSectionTableViewCell: BaseTableViewCell {
    
    let titleLabel = HomeDefaultSectionTitleLabel()
    let chevronImageView = HomeDefaultSectionChevronImageView(frame: .zero)
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [titleLabel, chevronImageView].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        // 피그마 상에서 잡았을 때 정확하게 영역이 어디까지인지를 모르겄네
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(13)
            make.centerY.equalTo(contentView)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(16)
            make.centerY.equalTo(contentView)
        }
    }
    
    func designCell(_ text: String) {
        titleLabel.setText(text)
    }
}
