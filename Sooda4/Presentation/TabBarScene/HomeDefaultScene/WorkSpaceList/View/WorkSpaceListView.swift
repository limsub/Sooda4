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
    var type: WorkSpaceEmptyOrNot = .empty
    
    convenience init(_ type: WorkSpaceEmptyOrNot) {
        self.init()
        
        self.type = type
        setUp()
    }
    
    
    /* ===== UI 객체 ===== */
    // 1.
    // - 레이블1, 레이블2, 버튼1
    let firstLabel = {
        let view = UILabel()
        view.text = "레이블 1"
        view.backgroundColor = .gray
        return view
    }()
    let secondLabel = {
        let view = UILabel()
        view.text = "레이블 2"
        view.backgroundColor = .green
        return view
    }()
    let addWorkSpaceButton = {
        let view = UIButton()
        view.setTitle("워크스페이스 만들기", for: .normal)
//        view.backgroundColor = .red
        return view
    }()
    
    
    // 2.
    // - 테이블뷰
    // 셀 height = 72
    // 내부 UIView height 60. 좌우 padding 8 -> cornerradius
    let workSpaceTableView = {
        let view = UITableView(frame: .zero)
        view.register(WorkSpaceListTableViewCell.self, forCellReuseIdentifier: WorkSpaceListTableViewCell.description())
        view.rowHeight = 72
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    // 공통
    // - 워크스페이스 추가, 도움말
    // - 가짜뷰
    let addWorkSpaceButtonView = WorkSpaceListCustomButton(text: "워크스페이스 추가", imageName: "icon_plus")
    let helpButtonView = WorkSpaceListCustomButton(text: "도움말", imageName: "icon_help")
    let fakeBackView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(.background_primary)
        return view
    }()
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        // 공통
        [fakeBackView, addWorkSpaceButtonView, helpButtonView].forEach { item  in
            self.addSubview(item)
        }
        
        // 1.
        [firstLabel, secondLabel, addWorkSpaceButton].forEach { item  in
            self.addSubview(item)
        }
        
        // 2.
        self.addSubview(workSpaceTableView)
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
        fakeBackView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.horizontalEdges.equalTo(self)
        }
        
        // 1.
        firstLabel.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(100)
        }
        secondLabel.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.centerX.equalTo(self)
            make.top.equalTo(firstLabel.snp.bottom).offset(20)
        }
        addWorkSpaceButton.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.centerX.equalTo(self)
            make.top.equalTo(secondLabel.snp.bottom).offset(20)
        }
        
        // 2.
        workSpaceTableView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(addWorkSpaceButtonView.snp.top)
        }
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .white
    }
    
    func setUp() {
        switch type {
        case .empty:
            firstLabel.isHidden = false
            secondLabel.isHidden = false
            addWorkSpaceButton.isHidden = false
            
            workSpaceTableView.isHidden = true
            
        case .notEmpty:
            firstLabel.isHidden = true
            secondLabel.isHidden = true
            addWorkSpaceButton.isHidden = true
            
            workSpaceTableView.isHidden = false
        }
    }
}
