//
//  HomeDefaultView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import UIKit

class HomeDefaultView: BaseView {
    
    let tableView = {
        let view = UITableView(frame: .zero)
        view.register(HomeDefaultSectionTableViewCell.self, forCellReuseIdentifier: HomeDefaultSectionTableViewCell.description())
        view.register(HomeDefaultChannelTableViewCell.self, forCellReuseIdentifier: HomeDefaultChannelTableViewCell.description())
        view.register(HomeDefaultDMTableViewCell.self, forCellReuseIdentifier: HomeDefaultDMTableViewCell.description())
        view.register(HomeDefaultPlusTableViewCell.self, forCellReuseIdentifier: HomeDefaultPlusTableViewCell.description())
        
        
        view.separatorColor = .red
        
        view.separatorStyle = .singleLine
        
        view.sepa
        
        // 기타 설정
//        view.showsVerticalScrollIndicator = false
//        
//        view.rowHeight = 140
//        view.contentInset = .zero
//        view.separatorInset = .zero
//        view.separatorStyle = .none
//        
//        view.backgroundColor = .white
//        
//        view.allowsSelection = false
        
        view.backgroundColor = .green
        
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
