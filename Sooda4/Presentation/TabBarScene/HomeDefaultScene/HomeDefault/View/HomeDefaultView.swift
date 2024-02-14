//
//  HomeDefaultView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import UIKit

extension UITableViewCell {

    // 해당 셀 기준으로 아래 구분선이 지워짐
    // 추가하기 빼고 다 지우면 되지 않나?
    // -> 접었을 때 문제가 생기네... 훔.
  func hideSeparator() {
    self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
  }

  func showSeparator() {
    self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}

class HomeDefaultView: BaseView {
    
    let tableView = {
        let view = UITableView(frame: .zero)
        view.register(HomeDefaultSectionTableViewCell.self, forCellReuseIdentifier: HomeDefaultSectionTableViewCell.description())
        view.register(HomeDefaultChannelTableViewCell.self, forCellReuseIdentifier: HomeDefaultChannelTableViewCell.description())
        view.register(HomeDefaultDMTableViewCell.self, forCellReuseIdentifier: HomeDefaultDMTableViewCell.description())
        view.register(HomeDefaultPlusTableViewCell.self, forCellReuseIdentifier: HomeDefaultPlusTableViewCell.description())
        
        
        view.separatorColor = .lightGray
        view.separatorInset = .zero
        
        

        
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
        
//        view.backgroundColor = .green
        
        return view
    }()
    
    let floatingButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.cornerRadius = 27
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(tableView)
        self.addSubview(floatingButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        floatingButton.snp.makeConstraints { make in
            make.size.equalTo(54)
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
    
}
