//
//  DMListView.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import UIKit

class DMListView: BaseView {
    
    let dmListTableView = {
        let view = UITableView()
        
        view.register(DMListTableViewCell.self, forCellReuseIdentifier: DMListTableViewCell.description())
        
        view.rowHeight = UITableView.automaticDimension
        
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(dmListTableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dmListTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
