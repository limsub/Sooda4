//
//  ChannelChattingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa


class ChannelChattingViewController: BaseViewController {
    
    private var viewModel: ChannelChattingViewModel!
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: ChannelChattingViewModel) -> ChannelChattingViewController {
        let vc = ChannelChattingViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    // 네비게이션 영역에 넣을 버튼
    let channelSettingButton = UIBarButtonItem(image: UIImage(named: "icon_list"), style: .plain, target: nil, action: nil)
    
    
    // 데이터 불러오라는 이벤트
    let loadData = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        setNavigation("하이")
        setNavigationButton()
        
        bindVM()
        loadData.onNext(())
    }
    
    func setNavigationButton() {
        navigationItem.rightBarButtonItem = channelSettingButton
        
        
        channelSettingButton.rx.tap
            .subscribe(with: self) { owner , _ in
                print("000")
            }
            .disposed(by: disposeBag)
    }
    
    func bindVM() {
        
        let input = ChannelChattingViewModel.Input(
            loadData: self.loadData,
            channelSettingButtonClicked: channelSettingButton.rx.tap
        )
        
        let output = viewModel.transform(input)
         
        
    }
}
