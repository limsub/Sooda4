//
//  ChannelSettingHandleChannelTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit
import RxSwift
import RxCocoa

// 버튼 높이 44 + 위아래 패딩 4 -> 셀 높이 52
// 버튼 좌우 패딩 24. 셀은 너비 screen에 동일
// 버튼 커스텀
class ChannelSettingHandleChannelTableViewCell: BaseTableViewCell {
    
    let handleButton = ChannelSettingHandleButton()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(handleButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        handleButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.horizontalEdges.equalTo(contentView).inset(24)
        }
    }
    
    
    func designCell(text: String, isRed: Bool) {
        handleButton.setUp(text: text, isRed: isRed)
        
    }
}
