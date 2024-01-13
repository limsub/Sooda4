//
//  ChangeAdminView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import UIKit

class ChangeAdminView: BaseView {
    
    let memberListTableView = {
        let view = UITableView(frame: .zero)
        view.register(MemberListTableViewCell.self, forCellReuseIdentifier: MemberListTableViewCell.description())
        view.rowHeight = 60
        view.separatorStyle = .none
        view.backgroundColor = UIColor.appColor(.background_primary)
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(memberListTableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        memberListTableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
}
