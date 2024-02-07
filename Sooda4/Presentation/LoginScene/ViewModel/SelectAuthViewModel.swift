//
//  SelectAuthViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation
import RxSwift
import RxCocoa

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser


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
        
        let a = UserApi.shared.rx.loginWithKakaoAccount()
        
        input.appleLoginButtonClicked
            .subscribe(with: self) { [self] owner , _ in
                
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.rx.loginWithKakaoTalk()
                        .subscribe(with: self) { owner , oauthToken in
                            print("loginWithKakaoTalk Success")
                            
                            
                        }
                        .disposed(by: disposeBag)
                } else {
                    UserApi.shared.rx.loginWithKakaoAccount()
                        .subscribe(with: self) { owner , oauthToken in
                            print("loginWithKakaoAccount Success")
                        }
                        .disposed(by: disposeBag)
                }
                
            }
            .disposed(by: disposeBag)
        
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
