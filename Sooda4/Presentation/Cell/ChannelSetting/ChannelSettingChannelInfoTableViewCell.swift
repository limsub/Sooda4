//
//  ChannelSettingChannelInfoTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

// width : view와 동일. height : 유동적. .automaticDimension 예정
class ChannelSettingChannelInfoTableViewCell: BaseTableViewCell {
    
    let nameLabel = {
        let view = UILabel()
        view.text = "# 그냥 떠들고 싶을 때"
        view.setAppFont(.title2)
        view.numberOfLines = 1
        return view
    }()
    
    let descriptionLabel = {
        let view = UILabel()
        view.text = "안녕하세요 새싹 여러분? 심심하셨죠. 이 채널은 나머지 모든 것을 위한 채널이에요. 팀원들이 농담하거나 순간적인 아이디어를 공유하는 곳이죠! 마음껏 즐기세요 안녕하세요 새싹 여러분? 심심하셨죠. 이 채널은 나머지 모든 것을 위한 채널이에요. 팀원들이 농담하거나 순간적인 아이디어를 공유하는 곳이죠! 마음껏 즐기세요 안녕하세요 새싹 여러분? 심심하셨죠. 이 채널은 나머지 모든 것을 위한 채널이에요. 팀원들이 농담하거나 순간적인 아이디어를 공유하는 곳이죠! 마음껏 즐기세요 안녕하세요 새싹 여러분? 심심하셨죠. 이 채널은 나머지 모든 것을 위한 채널이에요. 팀원들이 농담하거나 순간적인 아이디어를 공유하는 곳이죠! 마음껏 즐기세요 안녕하세요 새싹 여러분? 심심하셨죠. 이 채널은 나머지 모든 것을 위한 채널이에요. 팀원들이 농담하거나 순간적인 아이디어를 공유하는 곳이죠! 마음껏 즐기세요"
        view.setAppFont(.body)
        view.numberOfLines = 0
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [nameLabel, descriptionLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(18)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(contentView).inset(8)   // 여기에 따라서 셀 높이 변함
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
    }
    
}
