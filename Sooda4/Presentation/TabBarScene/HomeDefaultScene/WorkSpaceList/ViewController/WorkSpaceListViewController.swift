//
//  WorkSpaceListViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class WorkSpaceListViewController: BaseViewController {
    
    let mainView = WorkSpaceListView()
    var viewModel: WorkSpaceListViewModel!
    
    let disposeBag = DisposeBag()
    
    
    static func create(with viewModel: WorkSpaceListViewModel) -> WorkSpaceListViewController {
        let vc = WorkSpaceListViewController()
        viewModel.vcViewDidLoad = vc.rx.viewDidLoad
        vc.viewModel = viewModel
        return vc
    }
    
    
    // 현재 워크스페이스 셀의 메뉴 버튼 클릭 -> menuButtonClicked 실행 -> input으로 이벤트 VM에 전달
//    var menuButtonClicked: ControlEvent<Void>?
    var menuButtonClicked = PublishSubject<Void>()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        
        setNavigation()
//        setTableView()
        bindVM()
    }
    
    func setNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "워크스페이스"
        titleLabel.setAppFont(.title1)
        
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.appColor(.background_primary)
//        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
    
    func setTableView() {
        mainView.workSpaceTableView.delegate = self
        mainView.workSpaceTableView.dataSource = self
    }
    
    func bindVM() {
        
        let input = WorkSpaceListViewModel.Input(
            itemSelected: mainView.workSpaceTableView.rx.itemSelected,
            menuButtonClicked: menuButtonClicked,
            addWorkSpaceButtonClicked: mainView.addWorkSpaceButtonView.sButton.rx.tap,
            helpButtonClicked: mainView.helpButtonView.sButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        
        // 테이블뷰 구성
        output.items
            .bind(to: mainView.workSpaceTableView.rx.items(cellIdentifier: WorkSpaceListTableViewCell.description(), cellType: WorkSpaceListTableViewCell.self)) {   (row, element, cell) in
                
                let isSelected = self.viewModel.checkSelectedWorkSpace(element)
                
                cell.designCell(isSelected: isSelected, model: element)
                
                cell.menuButton.rx.tap
                    .subscribe(with: self) { owner , value in
                        owner.menuButtonClicked.onNext(value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
    }
}

extension WorkSpaceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkSpaceListTableViewCell.description(), for: indexPath) as? WorkSpaceListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
