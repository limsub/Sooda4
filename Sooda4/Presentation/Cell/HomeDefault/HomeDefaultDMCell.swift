//
//  HomeDefaultDMCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import UIKit

class HomeDefaultDMTableViewCell: BaseTableViewCell {
    
    let label1 = {
        let view = UILabel()
        view.text = "디엠 셀"
        return view
    }()
    
    let label2 = {
        let view = UILabel()
        view.text = "hihihih"
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [label1, label2].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        label1.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(10)
        }
        label2.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
}

