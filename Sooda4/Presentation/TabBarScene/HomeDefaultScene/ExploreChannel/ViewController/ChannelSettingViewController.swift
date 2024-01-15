//
//  ChannelSettingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

class ChannelSettingViewController: BaseViewController {
    
    struct ButtonInfo {
        let title: String
        let isRed: Bool
    }
    let handleButtonData = [
        ButtonInfo(title: "채널 편집", isRed: false),
        ButtonInfo(title: "채널에서 나가기", isRed: false),
        ButtonInfo(title: "채널 관리자 변경", isRed: false),
        ButtonInfo(title: "채널 삭제", isRed: true )
    ]
    
    let mainView = ChannelSettingView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    
}


extension ChannelSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 4    // 관리자 여부에 따라 1 or 4 (vm에 저장)
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingChannelInfoTableViewCell.description()) as? ChannelSettingChannelInfoTableViewCell else { return UITableViewCell() }
            
            return cell
            
        case (1, 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingMemberFoldingTableViewCell.description()) as? ChannelSettingMemberFoldingTableViewCell else { return UITableViewCell() }
        
            
            return cell
            
        case (1, 1):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingMembersTableViewCell.description()) as? ChannelSettingMembersTableViewCell else { return UITableViewCell() }
            
            
            
            return cell
            
        case (2, _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingHandleChannelTableViewCell.description()) as? ChannelSettingHandleChannelTableViewCell else { return UITableViewCell() }
            
            let element = handleButtonData[indexPath.row]
            
            cell.designCell(text: element.title, isRed: element.isRed)
            
            
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0): return UITableView.automaticDimension

            
        case (1, 0): return 56

            
        case (1, 1): return UITableView.automaticDimension
   
            
        case (2, _): return 52
            
            
        default: return 0
        }
        
        
    }
    
}
