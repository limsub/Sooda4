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
    
    private let socialLoginUseCase: SocialLoginUseCaseProtocol
    private let myWorkspaceUseCase: WorkSpaceUseCaseProtocol
    
    // Coordinator에게 어떤 화면으로 전환할지 요청
    var didSendEventClosure: ( (SelectAuthViewModel.Event) -> Void)?
    
    init(socialLoginUseCase: SocialLoginUseCaseProtocol,
         myWorkspaceUseCase: WorkSpaceUseCaseProtocol
    ) {
        self.socialLoginUseCase = socialLoginUseCase
        self.myWorkspaceUseCase = myWorkspaceUseCase
    }
    
    
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
            .flatMap { response -> Single< Result< KakaoLoginResponseModel, NetworkError > > in
                
                switch response {
                case .success(let oauthToken):
                    let requestModel = KakaoLoginRequestModel(
                        oauthToken: oauthToken.accessToken,
                        deviceToken: UserDefaults.standard.string(forKey: "hi")!
                    )

                    return self.socialLoginUseCase.kakaoLoginRequest(requestModel)
                    
                case .failure(let error):
                    return Single.create { single in
                        single(.success(.failure(NetworkError(error.localizedDescription)))) as! any Disposable
                    }
                }
            }
            .filter { response in
                print("**** 결과 ****")
                
                switch response {
                case .success(let model):
                    // 키체인 업데이트
                    KeychainStorage.shared.accessToken = model.token.accessToken
                    KeychainStorage.shared.refreshToken = model.token.refreshToken
                    KeychainStorage.shared._id = model.userId
                    
                    print("--- 토큰 업데이트 ---")
                    KeychainStorage.shared.printTokens()
                    
                    return true

                    
                case .failure(let networkError):
                    print(networkError)
                    return false
                }
            }
            .flatMap { value in
                // 내가 속한 워크스페이스 조회
                self.myWorkspaceUseCase.myWorkSpacesRequest()
            }
            .subscribe(with: self) { owner , response in
                switch response {
                case .success(let model):
                    if model.isEmpty {
                        print("소속된 워크스페이스 없음. go HomeEmpty")
                        owner.didSendEventClosure?(.goHomeEmptyView)
                    } else {
                        print("소속된 워크스페이스 있음. go HomeDefault")
                        let workspaceID = model[0].workSpaceId
                        owner.didSendEventClosure?(.goHomeDefaultView(workspaceID: workspaceID))
                    }
                    
                case .failure(let networkError):
                    print(networkError)
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
        
        case goHomeEmptyView
        case goHomeDefaultView(workspaceID: Int)
    }
}
