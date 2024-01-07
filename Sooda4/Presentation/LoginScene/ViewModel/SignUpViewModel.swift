//
//  SignUpViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation
import RxSwift
import RxCocoa

struct ErrorResponse: Decodable {
    let errorCode: String
}

enum NetworkError: Error {
    // 서버에서 주는 에러가 아닌, 실제 에러(?) 알라모파이어 에러 이런거
    case unknown(message: String)
    
    // 서버에서 주는 에러 종류
    case E11    // 잘못된 요청 (이메일 유효성)
    case E12    // 중복 데이터 (이메일 유효성)
    
    init(_ error: String) {
        
        switch error {
        case "E11": self = .E11
        case "E12": self = .E12
        default: self = .unknown(message: error)
        }
    }
}



enum ResultValidEmailCheck {
    case success
    
    case failure(error: NetworkError)
}

enum ResultSignUp {
    case success(a: String)  // 응답값을 받았을 때 내가 필요한 정보만 저장 -> Domain Layer의 Entity에 저장해두자. 아마 토큰만 필요할 듯 싶음
    
    case failure(error: NetworkError)
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
        
//        let resultValidEmailCheck: PublishSubject<ResultValidEmailCheck>
        let resultSignUp: PublishSubject<ResultSignUp>
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
        
        
        // 사실상 reusltValidEmailCheck은 필요가 없네. 어차피 validEmailStore에 다 있음
//        let resultValidEmailCheck = PublishSubject<ResultValidEmailCheck>()
        let resultSignUp = PublishSubject<ResultSignUp>()
        
        
        
        
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
                
                // 비밀번호 확인 -> values3도 같이 써야 해서 따로 메서드 만들지 않고 여기서 처리
                if checkPw.isEmpty { validCheckPassWordStore.onNext(.nothing) }
                else if checkPw != pw { validCheckPassWordStore.onNext(.incorrect) }
                else { validCheckPassWordStore.onNext(.correct) }
                
                
                // 중복 확인 버튼
                enabledEmailValidationButton.onNext(
                    owner.checkEmailFormat(email) != .nothing
                )
                
                // 가입하기 버튼
                enabledCompletButton.onNext(
                    !email.isEmpty
                    && !nickname.isEmpty
                    && !phoneNum.isEmpty
                    && !pw.isEmpty
                    && !checkPw.isEmpty
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
                
                print("validEmailStore : ", try? validEmailStore.value())

                // 이메일 형식에 맞지 않거나, 이미 검증한 값이면 네트워크 콜 쏘지 않는다
                if value == .nothing || value == .invalidFormat || value == .available {
                    validEmailOutput.onNext(value)
                    print("이메일 버튼 클릭 -> filter false")
                    return false
                } else {
                    print("이메일 버튼 클릭 -> filter true")
                    return true
                }
            }
            .withLatestFrom(input.emailText)
            .flatMap {
                self.signUpUseCase.checkValidEmail($0)
            }
            .subscribe(with: self) { owner , response  in
                switch response {
                case .success:  // Empty Data이기 때문에 받는거 없음.
                    // 이메일 유효성 검증 성공
                    // 1.
                    validEmailStore.onNext(.available)
                    validEmailOutput.onNext(.available)
//                    // 2.
//                    resultValidEmailCheck.onNext(.success)
                    
                    
                case .failure(let networkError):
                    // 이메일 유효성 검증 실패
                    // 1.
                    if case .E12 = networkError {
                        print("이메일 유효성 - 중복 데이터 - alreadyExistedEmail")
                        validEmailStore.onNext(.alreadyExistedEmail)
                        validEmailOutput.onNext(.alreadyExistedEmail)
                    }
                    else {
                        print("이메일 유효성 - 알 수 없는 에러 - unknownedError")
                        validEmailStore.onNext(.unknownedError)
                        validEmailOutput.onNext(.unknownedError)
                    }
                    
//                    // 2.
//                    resultValidEmailCheck.onNext(.failure(error: networkError))
                }
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
            
//            resultValidEmailCheck: resultValidEmailCheck,
            resultSignUp: resultSignUp
        )
    }
    
    
    
    func checkEmailFormat(_ txt: String) -> ValidEmail {
        if txt.isEmpty { return .nothing }
        else if txt.count > 3 && txt.count < 10 { return .validFormatNotChecked }
        else { return .invalidFormat }
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
 
    
}
