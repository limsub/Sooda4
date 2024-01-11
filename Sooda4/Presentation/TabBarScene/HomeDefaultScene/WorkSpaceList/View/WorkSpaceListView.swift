//
//  WorkSpaceListView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import UIKit

enum WorkSpaceEmptyOrNot {
    case empty
    case notEmpty
}

class WorkSpaceListView: BaseView {
    
    // 1. 워크스페이스가 없는 경우
    // 2. 워크스페이스가 있는 경우
    var type: WorkSpaceEmptyOrNot?
    
    convenience init(_ type: WorkSpaceEmptyOrNot) {
        self.init()
        
        self.type = type
    }
    
    
    // 1.
    // - 레이블1, 레이블2, 버튼1
    
    // 2.
    // - 테이블뷰
    // 셀 height = 72
    // 내부 UIView height 60. 좌우 padding 8 -> cornerradius
    
    // 공통
    // - 워크스페이스 추가, 도움말
    let addWorkSpaceButtonView = WorkSpaceListCustomButton(text: "워크스페이스 추가", imageName: "icon_plus")
    let helpButtonView = WorkSpaceListCustomButton(text: "도움말", imageName: "icon_help")
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        // 공통
        [addWorkSpaceButtonView, helpButtonView].forEach { item  in
            self.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        // 공통
        helpButtonView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(41)
            make.bottom.equalTo(self).inset(33)
        }
        addWorkSpaceButtonView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(41)
            make.bottom.equalTo(helpButtonView.snp.top)
        }
    }
    
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .white
    }
}
