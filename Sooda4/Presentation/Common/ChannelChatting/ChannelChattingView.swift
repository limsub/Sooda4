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
        
        view.register(ChannelChattingTableViewCell.self, forCellReuseIdentifier: ChannelChattingTableViewCell.description())
        
        view.register(ChannelChattingSeperatorTableViewCell.self, forCellReuseIdentifier: ChannelChattingSeperatorTableViewCell.description())
        
        view.backgroundColor = .white
        
        view.rowHeight = UITableView.automaticDimension
        
        view.contentInset = .zero
        
        
        return view
    }()
    
    let chattingInputBackView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let chattingInputView = ChannelChattingInputView()

    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(chattingTableView)
        self.addSubview(chattingInputBackView)
        self.addSubview(chattingInputView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        

        
        
        
        chattingInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-12)
        }
        
        
        chattingInputBackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.top.equalTo(chattingInputView.snp.top).inset(-8)
            make.bottom.equalTo(chattingInputView.snp.bottom).offset(50)
        }
        
        chattingTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            
            // 키보드 레이아웃 + 그 때 chattingInputView height만큼
            make.bottom.equalTo(chattingInputBackView.snp.top)
        }
    }
    
    override func setting() {
        super.setting()
        
        chattingInputView.fileImageCollectionView.isHidden = false
        self.setConstraints()
    }
    
}
