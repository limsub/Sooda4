//
//  DMListViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import UIKit

class DMListViewController: BaseViewController {
    
    let mainView = DMListView()
    
    
    // Navigation 영역
    let customNavigationItemView = UIButton()
    let leftImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "profile_No Photo A")
        return view
    }()
    let navigationTitleLabel = {
        let view = UILabel()
        view.text = "Direct Message"
        view.setAppFont(.title1)
        return view
    }()
    let rightImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.image = UIImage(named: "profile_No Photo B")
        view.layer.borderColor = UIColor(hexCode: "#323538").cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        
        setNavigation()
        setTableView()
        setCollectionView()
    }
    
    /* === setting === */
    func setNavigation() {
        setCustomNavigation(
            customNavigationItemView: customNavigationItemView,
            leftImageView: leftImageView,
            navigationTitleLabel: navigationTitleLabel,
            rightImageView: rightImageView
        )
    }
    
    func setTableView() {
        mainView.dmListTableView.dataSource = self
        mainView.dmListTableView.delegate = self
    }
    
    func setCollectionView() {
        mainView.headerView.memberListCollectionView.delegate = self
        mainView.headerView.memberListCollectionView.dataSource = self
    }
}


// TableView
extension DMListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DMListTableViewCell.description(), for: indexPath) as? DMListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}


// CollectionView
extension DMListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelSettingMemberCollectionViewCell.description(), for: indexPath) as? ChannelSettingMemberCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
