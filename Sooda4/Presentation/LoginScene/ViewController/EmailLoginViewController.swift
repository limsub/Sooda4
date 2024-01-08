//
//  LoginViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class EmailLoginViewController: BaseViewController {
    
    private let mainView = EmailLoginView()
    private var viewModel: EmailLoginViewModel!
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: EmailLoginViewModel) -> EmailLoginViewController {
        let vc = EmailLoginViewController()
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
        navigationItem.title = "이메일 로그인"
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
        let input = EmailLoginViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            completeButtonClicked: mainView.completeButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        // 1. 이메일 레이블
        output.validEmail
            .subscribe(with: self) { owner , value in
                switch value {
                case .invalidFormat:
                    print(" - 이메일 빨간색")
                    owner.mainView.emailTitleLabel.update(.disabled)
                    
                case .validFormatNotChecked:
                    owner.mainView.emailTitleLabel.update(.enabled)
                    
                default:
                    break
                }
                
            }
            .disposed(by: disposeBag)
        
        // 2. 비밀번호 레이블
        output.validPw
            .subscribe(with: self) { owner , value in
                switch value {
                case .invalidFormat:
                    print(" - 비밀번호 빨간색")
                    owner.mainView.pwTitleLabel.update(.disabled)
                case .available:
                    owner.mainView.pwTitleLabel.update(.enabled)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        // 3. 로그인 버튼
        output.enabledLoginButton
            .subscribe(with: self) { owner , value in
                owner.mainView.completeButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        // 4. 실패 시 텍스트필드 포커스
        output.resultLogin
            .subscribe(with: self) { owner , value in
                switch value {
                case .firstInvalidFormatComponent(let component):
                    switch component {
                    case .email: print("이메일 텍스트필드 포커스")
                    case .pw: print("비밀번호 텍스트필드 포커스")
                    }
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
}
