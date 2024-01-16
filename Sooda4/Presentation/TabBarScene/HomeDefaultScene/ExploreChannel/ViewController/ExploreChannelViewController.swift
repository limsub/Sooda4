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
    var joinChannel = PublishSubject<WorkSpaceChannelInfoModel>()    // 확인 버튼을 눌렀을 때 이벤트
    
    // 네비게이션 x 버튼
    let xButton = UIBarButtonItem(image: UIImage(named: "icon_close")?.withTintColor(.black), style: .plain, target: nil, action: nil)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("채널 탐색")
        setNavigationXButton()
        bindVM()
        loadData.onNext(())
    }
    
    
    func bindVM() {
        
        let input = ExploreChannelViewModel.Input(
            xButtonClicked: xButton.rx.tap,
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
        
        
        // 만약 소속되지 않은 채널을 클릭했을 때, 해당 채널에 대한 정보와 함께 이벤트를 받는다.
        output.notJoinedChannel
            .subscribe(with: self) { owner , value in
                self.showCustomAlertTwoActionViewController(
                    title: "채널 참여",
                    message: "[\(value.name)] 채널에 참여하시겠습니까?",
                    okButtonTitle: "확인",
                    cancelButtonTitle: "취소") {
                        print("확인 누름")
                        owner.joinChannel.onNext(value) // 해당 채널에 새로 조인하겠다.
                        self.dismiss(animated: false)
                        
                    } cancelCompletion: {
                        print("취소 누름")
                        self.dismiss(animated: false)
                    }
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    func setNavigationXButton() {
        navigationItem.leftBarButtonItem = xButton
    }
}
