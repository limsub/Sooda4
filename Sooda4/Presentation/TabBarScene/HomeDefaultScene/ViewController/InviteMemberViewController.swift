//
//  InviteMemberViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class InviteMemberViewController: BaseViewController {
    
    private let mainView = InviteMemberView()
    private var viewModel: InviteMemberViewModel!
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: InviteMemberViewModel) -> InviteMemberViewController {
        let vc = InviteMemberViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("팀원 초대")
        bindVM()
    }
    
    func bindVM() {
        let input = InviteMemberViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            completeButtonClicked: mainView.completeButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.enabledCompleteButton
            .subscribe(with: self) { owner , value in
                owner.mainView.completeButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        output.resultInviteMember
            .subscribe(with: self) { owner , result in
                print("토스트 메세지 - \(result.toastMessage)")
            }
            .disposed(by: disposeBag)
    }
}
