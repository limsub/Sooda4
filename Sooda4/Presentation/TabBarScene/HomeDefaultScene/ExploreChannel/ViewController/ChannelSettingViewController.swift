//
//  ChannelSettingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

class ChannelSettingViewController: BaseViewController {
    
    private let mainView = ChannelSettingView()
    private var viewModel: ChannelSettingViewModel!
    
    static func create(with viewModel: ChannelSettingViewModel) -> ChannelSettingViewController {
        let vc = ChannelSettingViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        fetchData()
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
        
    func fetchData() {
        viewModel.fetchData {
            self.mainView.tableView.reloadData()
        }
    }
    
}


extension ChannelSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = viewModel.sectionType(indexPath: indexPath)
        
        switch sectionType {
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingChannelInfoTableViewCell.description()) as? ChannelSettingChannelInfoTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.channelInfoForInfoCell()
            cell.designCell(name: data.0, description: data.1)
            
            return cell
        case .memberFolding:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingMemberFoldingTableViewCell.description()) as? ChannelSettingMemberFoldingTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.memberCountForFoldingCell()
            cell.designCell(count: data)
            
            return cell
        case .members:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingMembersTableViewCell.description()) as? ChannelSettingMembersTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.memberInfoForMembersCell()
            cell.items = data
            cell.reloadCollectionView()
            
            return cell
        case .button:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingHandleChannelTableViewCell.description()) as? ChannelSettingHandleChannelTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.buttonDataForButtonCell(indexPath: indexPath)
            cell.designCell(text: data.0, isRed: data.1)
            
            return cell
        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sectionType = viewModel.sectionType(indexPath: indexPath)
        
        switch sectionType {
        case .info:
            return UITableView.automaticDimension
        case .memberFolding:
            return 56
        case .members:
            return UITableView.automaticDimension
        case .button:
            return 52
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.toggleOpenValue(indexPath: indexPath) {
            self.mainView.tableView.reloadSections([indexPath.section], with: .none)
        }
        
    }
    
}
