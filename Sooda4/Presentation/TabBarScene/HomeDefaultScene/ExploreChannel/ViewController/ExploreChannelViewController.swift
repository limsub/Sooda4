//
//  ExploreChannelViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class ExploreChannelViewController: BaseViewController {
    
    
    private let mainView = ExploreChannelView()
    private var viewModel: ExploreChannelViewModel!
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: ExploreChannelViewModel) -> ExploreChannelViewController {
        let vc = ExploreChannelViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    var loadData = PublishSubject<Void>()       // 테이블뷰에 띄울 데이터 로드
    var joinChannel = PublishSubject<String>()    // 확인 버튼을 눌렀을 때 이벤트
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("채널 탐색")
        bindVM()
        loadData.onNext(())
    }
    
    
    func bindVM() {
        
        let input = ExploreChannelViewModel.Input(
            loadData: self.loadData,
            itemSelected: mainView.tableView.rx.itemSelected,
            joinChannel: self.joinChannel
        )
        
        let output = viewModel.transform(input)
        
        output.items
            .bind(to: mainView.tableView.rx.items(cellIdentifier: HomeDefaultChannelTableViewCell.description(), cellType: HomeDefaultChannelTableViewCell.self)) { (row, element, cell) in
                
                cell.designWithBold(element.name)
            }
            .disposed(by: disposeBag)
        
        
        
        output.notJoinedChannel
            .subscribe(with: self) { owner , value in
                self.showCustomAlertTwoActionViewController(
                    title: "채널 참여",
                    message: "[\(value.name)] 채널에 참여하시겠습니까?",
                    okButtonTitle: "확인",
                    cancelButtonTitle: "취소") {
                        print("확인 누름")
                        owner.joinChannel.onNext(value.name) // 해당 채널에 새로 조인하겠다.
                        self.dismiss(animated: false)
                        
                    } cancelCompletion: {
                        print("취소 누름")
                        self.dismiss(animated: false)
                    }
            }
            .disposed(by: disposeBag)
        
        
        
    }
}
