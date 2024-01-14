//
//  MakeChannelViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

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
        bindVM()
    }
    
    func bindVM() {
        
        let input = MakeChannelViewModel.Input(
            nameText: mainView.nameTextField.rx.text.orEmpty,
            descriptionText: mainView.descriptionTextField.rx.text.orEmpty,
            completeButtonClicked: mainView.completeButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
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
