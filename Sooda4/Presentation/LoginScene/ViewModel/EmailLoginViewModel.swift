//
//  LoginViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation
import RxSwift
import RxCocoa

enum ResultLogin {
    // 네트워크 콜 x (텍스트필드 포커스 맞춰줄 곳 전달)
    case firstInvalidFormatComponent(textField: Component)
    
    // 네트워크 콜 o
    case success
    
    case failure(error: NetworkError)
    
    
    enum Component {
        case email, pw
    }
}

class EmailLoginViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    private let signUpUseCase: SignUpUseCaseProtocol
    
    var didSendEventClosure: ( (EmailLoginViewModel.Event) -> Void )?
    
    init(signUpUseCase: SignUpUseCaseProtocol) {
        self.signUpUseCase = signUpUseCase
    }
    
    struct Input {
        let emailText: ControlProperty<String>
        let pwText: ControlProperty<String>
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validEmail: PublishSubject<ValidEmail>
        // 여기서 사용할 ValidEmail은 사실상 3개. nothing, invalidFormat, validFormat
        let validPw: PublishSubject<ValidPassword>
        // 얘는 애초에 3개
        
        let enabledLoginButton: BehaviorSubject<Bool>
        
        let resultLogin: PublishSubject<ResultLogin>
    }
    
    func transform(_ input: Input) -> Output {
        // 이메일, 비밀번호 입력되면 로그인 버튼 색상 변화
        // 유효성 검증 통과 못하면 타이틀 컬러 변경, 텍스트필드 커서 활성화
        
        /* ===== output 객체 ===== */
        // 텍스트를 쓰는 동안에는 몰랐다가, 버튼 클릭이 되었을 때 유효성이 맞는지 여부를 알려줘야 함
        let validEmailStore = PublishSubject<ValidEmail>()
        let validEmailOutput = PublishSubject<ValidEmail>()
        
        let validPwStore = PublishSubject<ValidPassword>()
        let validPwOutput = PublishSubject<ValidPassword>()
        
        let enabledLoginButton = BehaviorSubject(value: false)
        
        let resultLogin = PublishSubject<ResultLogin>()
        
        
        
        /* ===== input 테스트 ===== */
        // 1. 이메일 format (Store 변경)
        input.emailText
            .subscribe(with: self) { owner , value in
                validEmailStore.onNext(owner.signUpUseCase.checkEmailFormat(value))
                
                print("이메일 : ", owner.signUpUseCase.checkEmailFormat(value))
            }
            .disposed(by: disposeBag)
        
        // 2. 비밀번호 format (Store 변경)
        input.pwText
            .subscribe(with: self) { owner , value in
                validPwStore.onNext(owner.signUpUseCase.checkPwFormat(value))
                
                print("비밀번호 : ", owner.signUpUseCase.checkPwFormat(value))
            }
            .disposed(by: disposeBag)
        
        
        // 3. 로그인 버튼 클릭 -> (Output 변경))
        let textSet = Observable.combineLatest(input.emailText, input.pwText)
        let validSet = Observable.combineLatest(validEmailStore, validPwStore)
        input.completeButtonClicked
            .withLatestFrom(validSet)
            .filter { values in
                
                let email = values.0
                let pw = values.1
                
                // 1. Output 전달
                validEmailOutput.onNext(email)
                validPwOutput.onNext(pw)
                
                
                // 2. 유효성 테스트
                if email == .validFormatNotChecked  // 케이스가 여러개라 이게 맞는거
                    && pw == .available {
                    print("모든 유효섬 검사 통과 - filter true")
                    return true
                } else {
                    if email != .validFormatNotChecked {
                        print(" - 이메일 유효성 문제 (텍스트필드 포커스)")
                        resultLogin.onNext(.firstInvalidFormatComponent(textField: .email))
                    } else if pw != .available {
                        print(" - 비밀번호 유효성 문제 (텍스트필드 포커스)")
                        resultLogin.onNext(.firstInvalidFormatComponent(textField: .pw))
                    }
                    return false
                }
            }
            .withLatestFrom(textSet) { validValue, textValues in
                let requestModel = LoginRequestModel(
                    email: textValues.0,
                    password: textValues.1,
                    deviceToken: "hi"
                )
                
                return requestModel
            }
            .flatMap {
                NetworkManager.shared.request(
                    type: SignInResponseDTO.self,
                    api: .signInRequest(
                        SignInRequestDTO(email: $0.email, password: $0.password, deviceToken: $0.deviceToken)
                    )
                )
            }
            .subscribe(with: self) { owner , response in
                print(response)
            }
            .disposed(by: disposeBag)
        
            
        
        return Output(
            validEmail: validEmailOutput,
            validPw: validPwOutput,
            enabledLoginButton: enabledLoginButton,
            resultLogin: resultLogin
        )
    }
    
    
    
}


extension EmailLoginViewModel {
    enum Event {
        case goHomeEmptyView, goHomeDefaultView
    }
}
