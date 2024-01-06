//
//  SignUpViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation
import RxSwift
import RxCocoa


// 1. API별로 enum을 다 만들어. 저번 LSLP 했던 것마냥
// 단, 프로토콜 하나 만들어서 공통 에러에 대한 처리를 해봐


//enum AError {
//    case a
//    case b
//    case commonError(errorCode: String)
//}
//
//enum BError {
//    case c
//    case d
//    case commonError(errorCode: String)
//}


enum ResultNetwork<T: Decodable> {
    case success(a: T)
    
    case failure(b: Int)
}

enum ResultSignUp {
    case success
    case fail_AlreadySigned
    case fail_unknowned
}

class SignUpViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    private let signUpUseCase: SignUpUseCaseProtocol
    
    init(signUpUseCase: SignUpUseCaseProtocol) {
        self.signUpUseCase = signUpUseCase
    }
    
    struct Input {
        let emailText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let phoneNumText: ControlProperty<String>
        let pwText: ControlProperty<String>
        let checkPwText: ControlProperty<String>
        
        let emailValidButtonClicked: ControlEvent<Void>
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validEmail: BehaviorSubject<ValidEmail>
        let validNickname: BehaviorSubject<ValidNickname>
        let validPhoneNum: BehaviorSubject<ValidPhoneNum>
        let validPassword: BehaviorSubject<ValidPassword>
        let validCheckPassword: BehaviorSubject<ValidCheckPassword>
        
        let enabledEmailValidationButton: BehaviorSubject<Bool>
        let enabledCompleteButton: BehaviorSubject<Bool>
        
        let resultSignUp: BehaviorSubject<ResultSignUp>
    }
    
    func transform(_ input: Input) -> Output {
        
        // 텍스트를 쓰는 동안에는 몰랐다가, 가입하기 버튼을 눌러야 valid 여부를 알려준다...
        // 변수 두 개 만들어두고, 한쪽 변수에다 계속 저장해두고, 버튼 누를 때 output으로 전달할 나머지 변수에 딱 던져주자
        // 주의 : Output 값이 바뀔 때에는 동일한 값을 Store에도 던져주자. 조건문 처리 할 때는 항상 Store로 했다.
        
        let validEmailStore = BehaviorSubject(value: ValidEmail.nothing)
        let validEmailOutput = BehaviorSubject(value: ValidEmail.nothing)
        
        let validNicknameStore = BehaviorSubject(value: ValidNickname.nothing)
        let validNicknameOutput = BehaviorSubject(value: ValidNickname.nothing)
        
        let validPhoneNumStore = BehaviorSubject(value: ValidPhoneNum.nothing)
        let validPhoneNumOutput = BehaviorSubject(value: ValidPhoneNum.nothing)
        
        let validPassWordStore = BehaviorSubject(value: ValidPassword.nothing)
        let validPassWordOutput = BehaviorSubject(value: ValidPassword.nothing)
        
        let validCheckPassWordStore = BehaviorSubject(value: ValidCheckPassword.nothing)
        let validCheckPassWordOutput = BehaviorSubject(value: ValidCheckPassword.nothing)
        
        
        let enabledEmailValidationButton = BehaviorSubject(value: false)
        let enabledCompletButton = BehaviorSubject(value: false)
        
        let resultSignUp = BehaviorSubject<ResultSignUp>(value: .success)
        
        
        // 텍스트필드 하나라도 바뀌기만 하면 한 방에 검사때려 그냥
        let textSet = Observable.combineLatest(
            input.emailText, input.nicknameText, input.phoneNumText, input.pwText, input.checkPwText)
        textSet
            .subscribe(with: self) { owner , values in
                
                let email = values.0
                let nickname = values.1
                let phoneNum = values.2
                let pw = values.3
                let checkPw = values.4
                
                print(email, nickname, phoneNum, pw, checkPw)
                
                // 이메일
                validEmailStore.onNext(owner.checkEmailFormat(email))
                
                // 닉네임
                validNicknameStore.onNext(owner.checkNicknameFormat(nickname))
                
                // 연락처
                validPhoneNumStore.onNext(owner.checkPhoneNumFormat(phoneNum))
                
                // 비밀번호
                validPassWordStore.onNext(owner.checkPwFormat(pw))
                
                // 비밀번호 확인
                validCheckPassWordStore.onNext(owner.checkCheckPwFormat(checkPw))
                
                // 중복 확인 버튼
                enabledEmailValidationButton.onNext(
                    owner.checkEmailFormat(email) != .nothing
                )
                
                // 가입하기 버튼
                enabledCompletButton.onNext(
                    owner.checkEmailFormat(email) != .nothing
                    && owner.checkNicknameFormat(nickname) != .nothing
                    && owner.checkPhoneNumFormat(phoneNum) != .nothing
                    && owner.checkPwFormat(pw) != .nothing
                    && owner.checkCheckPwFormat(checkPw) != .nothing
                )
            }
            .disposed(by: disposeBag)
        
      
        // 이메일 버튼 클릭
            // 1. 이메일 형식에 맞지 않음 -> 네트워크 콜 x. Toast: "이메일 형식이 올바르지 않습니다"
            // 2. 이메일 형식에 맞고, 아직 검증 안함 -> 네트워크 o
            //   2 - 1. ok -> "사용 가능한 이메일입니다"
            //   2 - 2. no -> "중복된 이메일입니다" <- 얘 왜 명세서에 없냐
            // 3. 이메일 형식에 맞고, 이미 검증 함 -> 네트워크 x. Toast: "사용 가능한 이메일입니다"
        input.emailValidButtonClicked
            .withLatestFrom(validEmailStore)
            .filter { value in
                // 이메일 형식에 맞지 않거나, 이미 검증한 값이면 네트워크 콜 쏘지 않는다
                if value == .nothing || value == .available {
                    validEmailOutput.onNext(value)
                    return false
                } else {
                    return true
                }
            }
            .withLatestFrom(input.emailText)
            .flatMap {
                self.signUpUseCase.checkValidEmail($0)
            }
            .subscribe(with: self) { owner , response  in
                print(response)
            }
            .disposed(by: disposeBag)
            
        
        
        return Output(
            validEmail: validEmailOutput,
            validNickname: validNicknameOutput,
            validPhoneNum: validPhoneNumOutput,
            validPassword: validPassWordOutput,
            validCheckPassword: validCheckPassWordOutput,
            
            enabledEmailValidationButton: enabledEmailValidationButton,
            enabledCompleteButton: enabledCompletButton,
            
            resultSignUp: resultSignUp
        )
    }
    
    
    
    func checkEmailFormat(_ txt: String) -> ValidEmail {
        if txt.isEmpty { return .nothing }
        else { return .validFormatNotChecked }
    }
    
    func checkNicknameFormat(_ txt: String) -> ValidNickname {
        if txt.isEmpty { return .nothing }
        else { return .invalidFormat }
    }
    
    func checkPhoneNumFormat(_ txt: String) -> ValidPhoneNum {
        if txt.isEmpty { return .nothing }
        else { return .invalidFormat }
    }
    
    func checkPwFormat(_ txt: String) -> ValidPassword {
        if txt.isEmpty { return .nothing }
        else { return .invalidFormat }
    }
    
    func checkCheckPwFormat(_ txt: String) -> ValidCheckPassword {
        if txt.isEmpty { return .nothing }
        else { return .incorrect}
    }
    
}
