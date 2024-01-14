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
    
    var mainView: WorkSpaceListView!
    var viewModel: WorkSpaceListViewModel!
    
    let disposeBag = DisposeBag()
    
    
    static func create(
        with viewModel: WorkSpaceListViewModel,
        view: WorkSpaceListView
    ) -> WorkSpaceListViewController {
        let vc = WorkSpaceListViewController()
        vc.mainView = view
        vc.viewModel = viewModel
        return vc
    }
    
    
    // 현재 워크스페이스 셀의 메뉴 버튼 클릭 -> menuButtonClicked 실행 -> input으로 이벤트 VM에 전달
//    var menuButtonClicked: ControlEvent<Void>?
    var menuButtonClicked = PublishSubject<Void>()
    var loadData = PublishSubject<Void>()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLargeTitleNavigation("워크스페이스")
        bindVM()
        
        loadData.onNext(()) // 데이터 로드 (viewDidLoad 대신 사용)
        
        
        navigationController?.navigationBar.clipsToBounds = true
        view.backgroundColor = .red
        
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    

    func bindVM() {
        
        let input = WorkSpaceListViewModel.Input(
            loadData: self.loadData,
            itemSelected: mainView.workSpaceTableView.rx.itemSelected,
            menuButtonClicked: menuButtonClicked,
            addWorkSpaceButtonClicked: mainView.addWorkSpaceButtonView.sButton.rx.tap,
            addWorkSpaceButtonClicked2: mainView.addWorkSpaceButton.rx.tap,
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
