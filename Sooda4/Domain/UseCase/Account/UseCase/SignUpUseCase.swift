//
//  SignUpUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpUseCaseProtocol {
    
    /* === 네트워크 === */
    func checkValidEmail(_ email: String) -> Single< Result<String, NetworkError> >
    
    func requestSignUp(_ requestModel: SignUpRequestModel) -> Single< Result< SignUpResponseModel, NetworkError> >
    
    
    /* === 로직 === */
    func checkEmailFormat(_ txt: String) -> ValidEmail
    func checkPwFormat(_ txt: String) -> ValidPassword
    func checkNicknameFormat(_ txt: String) -> ValidNickname
    func checkPhoneNumFormat(_ txt: String) -> ValidPhoneNum
}


class SignUpUseCase: SignUpUseCaseProtocol {
    
    // 1. repo
    let signUpRepository: SignUpRepositoryProtocol
    
    
    // 2. init (의존성 주입)
    init(signUpRepository: SignUpRepositoryProtocol) {
        self.signUpRepository = signUpRepository
    }
    
    
    // 3. 프로토콜 메서드 (네트워크)
    // (1). 이메일 유효성 검증
    func checkValidEmail(_ email: String) -> Single< Result<String, NetworkError> > {
        
        return signUpRepository.checkValidEmail(email)
        
    }
    
    // (2). 회원가입 시도
    func requestSignUp(_ requestModel: SignUpRequestModel) -> Single<Result<SignUpResponseModel, NetworkError>> {
        
        return signUpRepository.requestSignUp(requestModel)
    }
    
    
    // 4. 프로토콜 메서드 (로직)
    // (1). 이메일 형식 겁사 (SignUpVM, EmailLoginVM)
    func checkEmailFormat(_ txt: String) -> ValidEmail {
        if txt.isEmpty { return .nothing }
        else if txt.contains("@") && txt.contains(".com") { return .validFormatNotChecked }
        else { return .invalidFormat }
    }
    
    // (2). 비밀번호 형식 겁사 (SignUpVM, EmailLoginVM)
    func checkPwFormat(_ txt: String) -> ValidPassword {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        if txt.isEmpty { return .nothing }
        else if txt.count >= 8 && passwordTest.evaluate(with: txt) { return .available }
        else { return .invalidFormat }
    }
    
    // (3). 닉네임 (SignUpVM)
    func checkNicknameFormat(_ txt: String) -> ValidNickname {
        if txt.isEmpty { return .nothing }
        else if txt.count >= 1 && txt.count <= 30 { return .available }
        else { return .invalidFormat}
    }
    
    // (4). 연락처 (SignUpVM)
    func checkPhoneNumFormat(_ txt: String) -> ValidPhoneNum {
        if txt.isEmpty { return .nothing }
        else if txt.count == 12 || txt.count == 13 { return .available }
        else { return .invalidFormat}
        
    }
    

    
}



// UseCase의 역할이 단순 전달만..?
// 텍스트에 대한 유효성 검사도 UseCase에서 할 수 있지 않을까??
