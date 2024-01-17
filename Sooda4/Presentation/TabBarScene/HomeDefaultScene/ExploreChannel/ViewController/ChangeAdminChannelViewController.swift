//
//  ChangeAdminChannelViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/17/24.
//

import UIKit
import RxSwift
import RxCocoa

// 워크스페이스 관리자 권한 변경 -> rx 안쓰고 delegate로 처리
// 채널 관리자 권한 변경 -> rx 사용

class ChangeAdminChannelViewController: BaseViewController {
    
    private var viewModel: ChangeAdminChannelViewModel!
    private let mainView = ChangeAdminView()
    
    static func create(with viewModel: ChangeAdminChannelViewModel) -> ChangeAdminChannelViewController {
        let vc = ChangeAdminChannelViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("채널 관리자 변경")
        setTableView()
        fetchData()
    }
    
    func setTableView() {
        mainView.memberListTableView.delegate = self
        mainView.memberListTableView.dataSource = self
    }
    
    func fetchData() {
        
    }
    
    func bindVM() {
        
    }
}


extension ChangeAdminChannelViewController: UITableViewDelegate, UITableViewDataSource {

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberListTableViewCell.description(), for: indexPath) as? MemberListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
