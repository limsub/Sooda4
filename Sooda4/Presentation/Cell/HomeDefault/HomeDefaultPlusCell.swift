//
//  HomeDefaultPlusCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import UIKit

class HomeDefaultPlusTableViewCell: BaseTableViewCell {
    
    let plusImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_plus")
        return view
    }()
    
    let titleLabel = HomeDefaultCellTitleLabel()
    
    override func setConfigure() {
        super.setConfigure()
        
        [plusImageView, titleLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        plusImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalTo(contentView).inset(16)
            make.centerY.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(plusImageView.snp.trailing).offset(16)
            make.centerY.equalTo(contentView)
        }
    }
    
    func designCell(_ text: String) {
        titleLabel.setText(text)
    }
    
}

