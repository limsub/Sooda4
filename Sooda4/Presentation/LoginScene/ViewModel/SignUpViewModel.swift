//
//  SignUpViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation
import RxSwift
import RxCocoa


enum ResultValidEmailCheck {
    // 네트워크 콜 x
    case invalidFormat
    
    // 네트워크 콜 o
    case success
    
    case failure(error: NetworkError)
    
    var toastMessage: String {
        switch self {
        case .invalidFormat:
            return "이메일 형식이 올바르지 않습니다"
        case .success:
            return "사용 가능한 이메일입니다"
        case .failure(let error):
            switch error {
            case .E12:
                return "중복된 이메일입니다"
            default:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요"
            }
        }
    }

}

enum ResultSignUp {

    
    // 네트워크 콜 x (텍스트필드 포커스 맞춰줄 곳 전달.)
    case firstInvalidFormatComponent(textField: Component)
    
    // 네트워크 콜 o
    case success
    
    case failure(error: NetworkError)
    
    var toastMessage: String {
        switch self {
        case .firstInvalidFormatComponent(let textField):
            switch textField {
            case .email:
                // 이메일 형식이 올바르지 않더라도, 여기선 중복확인을 하지 않았다는 것만 판단
                return "이메일 중복 확인을 진행해주세요"
                
            case .nickname:
                return "닉네임은 1글자 이상 30글자 이내로 부탁드려요"
            case .phoneNum:
                return "잘못된 전화번호 형식입니다"
            case .pw:
                return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수문자를 설정해주세요"
            case .checkPw:
                return "작성하신 비밀번호가 일치하지 않습니다"
            }
        case .success:
            return "SignUp SUCCESS"
        case .failure(let error):
            switch error {
            case .E12:
                return "이미 가입된 회원입니다. 로그인을 진행해주세요"
            default:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요"
            }
        }
    }
    
    enum Component {
        case email, nickname, phoneNum, pw, checkPw
    }
}



class SignUpViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    private let signUpUseCase: SignUpUseCaseProtocol
    
    var didSendEventClosure: ( (SignUpViewModel.Event) -> Void)?
    
    
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
        
        let resultValidEmailCheck: PublishSubject<ResultValidEmailCheck>
        let resultSignUp: PublishSubject<ResultSignUp>
    }
    
    func transform(_ input: Input) -> Output {
        
        // 텍스트를 쓰는 동안에는 몰랐다가, 가입하기 버튼을 눌러야 valid 여부를 알려준다...
        // 변수 두 개 만들어두고, 한쪽 변수에다 계속 저장해두고, 버튼 누를 때 output으로 전달할 나머지 변수에 딱 던져주자
        // 주의 : Output 값이 바뀔 때에는 동일한 값을 Store에도 던져주자. 조건문 처리 할 때는 항상 Store로 했다.
        
        let validEmailStore = BehaviorSubject(value: ValidEmail.nothing)
        let validEmailOutput = BehaviorSubject(value: ValidEmail.nothing)
        
        validEmailStore.subscribe(with: self) { owner , value in
            print("이메일 스토어 바뀜!!0 - ", value)
        }.disposed(by: disposeBag)
      
        
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
        // 써야겠다. validEmailOutput으로 빼는 건 무조건 가입하기 버튼 눌렀을 때만 빼
        let resultValidEmailCheck = PublishSubject<ResultValidEmailCheck>()
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
                
                // 이메일 -> 이미 성공이 되었는데, 여기서 다시 체크해서 validFormatNotCHecked로 돌아가게 되어버린다. -> 분기처리
                // 와 근데 이메일을 수정한 경우에는 처리해줘야 해.... => 밖에다 따로 구현하자. 여기선 너무 빡셀듯
                let currentState = try? validEmailStore.value()
                if currentState != .available {
                    print("이메일 스토어 바꿈!!1 (textSet) - currentstate : ", currentState)
                    validEmailStore.onNext(owner.signUpUseCase.checkEmailFormat(email))
                }
                
                
                // 닉네임
                validNicknameStore.onNext(owner.signUpUseCase.checkNicknameFormat(nickname))
                
                // 연락처
                validPhoneNumStore.onNext(owner.signUpUseCase.checkPhoneNumFormat(phoneNum))
                
                // 비밀번호
                validPassWordStore.onNext(owner.signUpUseCase.checkPwFormat(pw))
                
                // 비밀번호 확인 -> values3도 같이 써야 해서 따로 메서드 만들지 않고 여기서 처리
                if checkPw.isEmpty { validCheckPassWordStore.onNext(.nothing) }
                else if checkPw != pw { validCheckPassWordStore.onNext(.incorrect) }
                else { validCheckPassWordStore.onNext(.correct) }
                
                
                // 중복 확인 버튼
                enabledEmailValidationButton.onNext(
                    owner.signUpUseCase.checkEmailFormat(email) != .nothing
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
        
        input.emailText
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                print("이메일 스토어 바꿈!!2 (따로) - ", value)
                validEmailStore.onNext(owner.signUpUseCase.checkEmailFormat(value))
            }
            .disposed(by: disposeBag)
        
      
        /* ===== 이메일 버튼 클릭 ===== */
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
                switch value {
                case .nothing:
                    print("이게 실행되면 문제가 있는거다. 버튼 활성화 자체가 안되었어야 함")
                    return false
                case .invalidFormat:
                    print("이메일 형식 invalid -> fliter false")
                    resultValidEmailCheck.onNext(.invalidFormat)
                    return false
                case .available:
                    print("이미 검증 완료 -> filter false")
                    resultValidEmailCheck.onNext(.success)
                    return false
                    
                default:
                    print("filter true")
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
//                    validEmailOutput.onNext(.available)
//                    // 2.
                    resultValidEmailCheck.onNext(.success)
                    
                    
                case .failure(let networkError):
                    // 이메일 유효성 검증 실패
                    // 1.
                    if case .E12 = networkError {
                        print("이메일 유효성 - 중복 데이터 - alreadyExistedEmail")
                        validEmailStore.onNext(.alreadyExistedEmail)
//                        validEmailOutput.onNext(.alreadyExistedEmail)
                    }
                    else {
                        print("이메일 유효성 - 알 수 없는 에러 - unknownedError")
                        validEmailStore.onNext(.unknownedError)
//                        validEmailOutput.onNext(.unknownedError)
                    }
                    
//                    // 2.
                    resultValidEmailCheck.onNext(.failure(error: networkError))
                }
            }
            .disposed(by: disposeBag)
            
        
        
        
        /* =====  회원가입 버튼 클릭 ===== */
        // 1. ValidStore 중 통과 안 된 애가 하나라도 있다. -> ValidOutput으로 (VC에게) 전달. 네트워크 콜 x. 이 때, 맨 위에 애가 포커스되도록 해야 한다...
        // 2. 네트워크 통신 실패 -> 메세지 토스트. ResultSignUp로 전달.
        //               성공 -> 메세지 토스트. 위와 동일
        let validSet = Observable.combineLatest(validEmailStore, validNicknameStore, validPhoneNumStore, validPassWordStore, validCheckPassWordStore)
        input.completeButtonClicked
            .withLatestFrom(validSet)
            .filter { values in
                
                let email = values.0
                let nickname = values.1
                let phoneNum = values.2
                let pw = values.3
                let checkPw = values.4
                
                validEmailOutput.onNext(email)
                validNicknameOutput.onNext(nickname)
                validPhoneNumOutput.onNext(phoneNum)
                validPassWordOutput.onNext(pw)
                validCheckPassWordOutput.onNext(checkPw)
                
                print("-----", try? validPhoneNumOutput.value())
                
                if email == .available
                    && nickname == .available
                    && phoneNum == .available
                    && pw == .available
                    && checkPw == .correct {
                    print("모든 유효성 검사 통과 - filter true")
                    return true
                }
                else {
                    if email != .available {
                        print("- 이메일 유효성 문제 : ", email)
                        resultSignUp.onNext(.firstInvalidFormatComponent(textField: .email))
                    } else if nickname != .available {
                        print("- 닉네임 유효성 문제")
                        resultSignUp.onNext(.firstInvalidFormatComponent(textField: .nickname))
                    } else if phoneNum != .available {
                        print("- 연락처 유효성 문제")
                        resultSignUp.onNext(.firstInvalidFormatComponent(textField: .phoneNum))
                    } else if pw != .available {
                        print("- 비밀번호 유효성 문제")
                        resultSignUp.onNext(.firstInvalidFormatComponent(textField: .pw))
                    } else if checkPw != .correct {
                        print("- 비밀번호 확인 유효성 문제")
                        resultSignUp.onNext(.firstInvalidFormatComponent(textField: .checkPw))
                    }
                    print("유효성 검사 실패 - filter false")
                    return false
                }
                
            }
            .withLatestFrom(textSet) { validValue, textValue  in
                let requestModel = SignUpRequestModel(
                    email: textValue.0,
                    nickname: textValue.1,
                    phoneNum: textValue.2,
                    password: textValue.3
                )
                
                return requestModel
            }
            .flatMap {
                self.signUpUseCase.requestSignUp($0)
            }
        // subscribe -> filter로 수정.
        // 한번 더 네트워크 통신이 진행이 되어야 함 (워크스페이스 유무)
        
        // 로직 구상
        // 1. filter 걸어서 성공일 때, 즉 로그인 성공했을 때 키체인에 토큰 넣어두고, return true
            // 로그인 실패면 return false
        // 2. (flatmap) /v1/workspaces 네트워크 쏴
        // 3. (subscribe)
            // 워크스페이스 개수 여부에 따라 코디네이터한테 화면 전환 요청
            // 만약 여기서 에러가 난다 -> 화면 전환 하면 안됨!! VC에 에러 보내서 토스트 메세지 띄워주기

        
        
            .subscribe(with: self) { owner , response in
                
                switch response {
                case .success:
                    resultSignUp.onNext(.success)
                    
                    // 다시 코디네이터
                    // 회원가입 성공 -> SelectAuth코디 종료 -> InitialWorkSpace 코디 실행
                    // 1. signUpView dismiss  2. selectAuthView dismiss  3. intialWorkSpaceView push
                    
                    owner.didSendEventClosure?(.goInitialWorkSpace)
                    
                case .failure(let networkError):
                    
                    resultSignUp.onNext(.failure(error: networkError))

                }
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
            
            resultValidEmailCheck: resultValidEmailCheck,
            resultSignUp: resultSignUp
        )
    }
}

extension SignUpViewModel {
    enum Event {
        case goInitialWorkSpace
    }
}
