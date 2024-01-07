//
//  SignUpViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    
    private let mainView = SignUpView()
    private var viewModel: SignUpViewModel!
    private let disposeBag = DisposeBag()
    
    static func create(with viewModel: SignUpViewModel) -> SignUpViewController {
        let vc = SignUpViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        bindVM()
    }
    
    func setNavigation() {
        navigationItem.title = "회원가입"
        if let sheetPresentationController {
            sheetPresentationController.prefersGrabberVisible = true
        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
//        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
    
    func bindVM() {
        let input = SignUpViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            nicknameText: mainView.nicknameTextField.rx.text.orEmpty,
            phoneNumText: mainView.phoneNumTextField.rx.text.orEmpty,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            checkPwText: mainView.checkPwTextField.rx.text.orEmpty,
            emailValidButtonClicked: mainView.checkEmailValidButton.rx.tap,
            completeButtonClicked: mainView.completeButton.rx.tap
        )

        let output = viewModel.transform(input)

        
        
        // 이메일 중복 확인 버튼 enabled
        output.enabledEmailValidationButton
            .subscribe(with: self) { owner , value in
                owner.mainView.checkEmailValidButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        // 가입하기 버튼 enabled
        output.enabledCompleteButton
            .subscribe(with: self) { owner , value in
                owner.mainView.completeButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        // output
        output.validEmail
            .subscribe(with: self) { owner , value  in
                // .nothing -> 버튼 눌리지도 않아
                // .invalidFormat
                print("VC : validEmail : ", value)
            }
            .disposed(by: disposeBag)
        

    }
}
