//
//  DMListView.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import UIKit

class DMListView: BaseView {
    
    let headerView = {
        let view = DMListTableViewHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 91)
        view.layer.borderColor = UIColor.appColor(.view_seperator).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var dmListTableView = {
        let view = UITableView()
        
        view.register(DMListTableViewCell.self, forCellReuseIdentifier: DMListTableViewCell.description())
        
        view.rowHeight = UITableView.automaticDimension
        
        view.tableHeaderView = headerView
        
        view.separatorStyle = .none
        
        return view
    }()
    
    
    let testButton = {
        let view = UIButton()
        view.backgroundColor = .red
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(dmListTableView)
        self.addSubview(testButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dmListTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        testButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.bottom.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
}
