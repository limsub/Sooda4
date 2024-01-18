//
//  ChannelChattingView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit

class ChannelChattingView: BaseView {
    
    let chattingTableView = {
        let view = UITableView(frame: .zero)
        
        view.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        
        view.backgroundColor = .red
        
    
        
        return view
    }()
    
//    let chattinTextView = ChannelChattingTextView()
    
    let chattingTextView = {
        let view = UITextView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        view.backgroundColor = .lightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false

        view.font = UIFont.appFont(.body)
        
        view.isScrollEnabled = false
        
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(chattingTableView)
        self.addSubview(chattingTextView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        chattingTableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
//        chattingTextView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(self)
//            make.centerY.equalTo(self)
//            make.height.equalTo(50)
//        }
        
        
        [ chattingTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
          chattingTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
          chattingTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
          chattingTextView.heightAnchor.constraint(equalToConstant: 50)
          
        ].forEach { $0.isActive = true}
        
        
    }
    
}
