//
//  MakeChannelViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

// 채널 만들기 / 수정하기 같이 쓴다

class MakeChannelViewController: BaseViewController {
    
    private let mainView = MakeChannelView()
    private var viewModel: MakeChannelViewModel!
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: MakeChannelViewModel) -> MakeChannelViewController {
        let vc = MakeChannelViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("채널 생성")
        settingType(type: viewModel.type)
        bindVM()
    }
    
    func settingType(type: MakeChannelViewModel.OperationType) {
        if case .make = type {
            mainView.completeButton.setTitle("생성", for: .normal)
            mainView.completeButton.setUp()
            
            navigationItem.title = "만들러 옴"
        }
        
        else {
            mainView.completeButton.setTitle("완료", for: .normal)
            mainView.completeButton.setUp()
            
            navigationItem.title = "수정하러 옴"
        }
    }
    
    func bindVM() {
        
        let input = MakeChannelViewModel.Input(
            nameText: mainView.nameTextField.rx.text.orEmpty,
            descriptionText: mainView.descriptionTextField.rx.text.orEmpty,
            completeButtonClicked: mainView.completeButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        // initialData가 있으면 초기 뷰 세팅해주기!
        output.initialModel
            .subscribe(with: self) { owner , value in
                print("--- 이니셜 데이터가 있다!")
                
                owner.mainView.nameTextField.text = value.channelName
                owner.mainView.nameTextField.sendActions(for: .valueChanged)
                
                owner.mainView.descriptionTextField.text = value.channelDescription
                owner.mainView.descriptionTextField.sendActions(for: .valueChanged)
            }
            .disposed(by: disposeBag)
        
        output.enabledCompleteButton
            .subscribe(with: self) { owner , value in
                owner.mainView.completeButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        output.resultMakeChannel
            .subscribe(with: self) { owner , result in
                print("토스트 메세지 : \(result.toastMessage)")
            }
            .disposed(by: disposeBag)
    }
}
