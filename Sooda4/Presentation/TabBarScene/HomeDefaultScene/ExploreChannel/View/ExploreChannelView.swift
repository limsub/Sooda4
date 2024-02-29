//
//  ExploreChannelView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit

class ExploreChannelView: BaseView {
    
    let tableView = {
        let view = UITableView(frame: .zero)
        view.register(HomeDefaultChannelTableViewCell.self , forCellReuseIdentifier: HomeDefaultChannelTableViewCell.description())
//        view.backgroundColor = .red
        view.separatorStyle = .none
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
