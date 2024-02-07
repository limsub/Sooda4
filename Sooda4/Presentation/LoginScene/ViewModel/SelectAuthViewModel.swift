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
        
        input.kakaoLoginButtonClicked
            .flatMap { result -> Single< Result< OAuthToken, Error > > in
                if UserApi.isKakaoTalkLoginAvailable() {
                    print("카톡 있음")
                    
                    return Single.create { single in
                        UserApi.shared.rx.loginWithKakaoTalk()
                            .subscribe(with: self) { owner , oAuthToken in
                                return single(.success(.success(oAuthToken)))
                            } onError: { owner , error in
                                return single(.success(.failure(error)))
                            }
                    }
                } else {
                    print("카톡 없음")
                    
                    return Single.create { single in
                        UserApi.shared.rx.loginWithKakaoAccount()
                            .subscribe(with: self) { owner , oAuthToken in
                                return single(.success(.success(oAuthToken)))
                            } onError: { owner , error  in
                                return single(.success(.failure(error)))
                            }
                    }
                }
            }
            .subscribe(with: self) { owner , response in
                print("**** 결과 ****")
                print(response)
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
