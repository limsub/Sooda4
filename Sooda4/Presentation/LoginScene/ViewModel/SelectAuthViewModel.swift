//
//  SelectAuthViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectAuthViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    // Coordinator에게 어떤 화면으로 전환할지 요청
    var didSendEventClosure: ( (SelectAuthViewModel.Event) -> Void)?
    
    
    // 필요한 로직
    // 1. 애플 로그인 (or 회원가입)
    // 2. 카카오 로그인 (or 회원가입)
    // 3. 이메일 로그인 -> presentEmailLoginView
    // 4. 회원가입     -> presentSignUpView
    
    
    
    struct Input {
        let appleLoginButtonClicked: ControlEvent<Void>
        let kakaoLoginButtonClicked: ControlEvent<Void>
        let emailLoginButtonClicked: ControlEvent<Void>
        let signUpButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let result: String
    }
    
    func transform(_ input: Input) -> Output {
        
        // 1. 애플 로그인
        
        // 2. 카카오 로그인
        
        // 3. 이메일 로그인
        input.emailLoginButtonClicked
            .subscribe(with: self) { owner , _ in
                self.didSendEventClosure?(.presentEmailLoginView)
            }
            .disposed(by: disposeBag)
        
        // 4. 회원가입
        input.signUpButtonClicked
            .subscribe(with: self) { owner , _ in
                self.didSendEventClosure?(.presentSignUpView)
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(result: "")
    }
}


extension SelectAuthViewModel {
    enum Event {
        case presentSignUpView
        case presentEmailLoginView
    }
}
