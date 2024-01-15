//
//  ChannelSettingView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

class ChannelSettingView: BaseView {
    
    // 섹션 3개
    
    // 첫 번째 섹션
        // 셀 1개 - View 넣어버리기
        // - .automaticDimension
    
    // 두 번째 섹션
        // 셀 2개 (펼쳤을 때) vs. 셀 1개 (접었을 때)
        // 1. 멤버 (14) >   - height 지정
        // 2. 컬렉션뷰       - height 지정 (직접 계산)
    
    // 세 번째 섹션
        // 셀 4개 (관리자) vs. 셀 1개 (일반)
        // 셀 내에 커스텀 버튼 지정.
    
    // 모든 셀 선택 불가 (세 번째 섹션에서 내부 버튼은 클릭 가능)
    // 하지만 멤버(14) 셀은 선택 가능해야 함...
    
    
    
    
    let tableView = {
        let view = UITableView(frame: .zero)
        
        
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
