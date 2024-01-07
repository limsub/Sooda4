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
    
    func checkValidEmail(_ email: String) -> Single< Result<String, NetworkError> >
    
    func requestSignUp(_ requestModel: SignUpRequestModel) -> Single< Result< SignUpResponseModel, NetworkError> >
    
}


class SignUpUseCase: SignUpUseCaseProtocol {
    
    // 1. repo
    let signUpRepository: SignUpRepositoryProtocol
    
    
    // 2. init (의존성 주입)
    init(signUpRepository: SignUpRepositoryProtocol) {
        self.signUpRepository = signUpRepository
    }
    
    
    // 3. 프로토콜 메서드
    // (1). 이메일 유효성 검증
    func checkValidEmail(_ email: String) -> Single< Result<String, NetworkError> > {
        
        return signUpRepository.checkValidEmail(email)
        
    }
    
    // (2). 회원가입 시도
    func requestSignUp(_ requestModel: SignUpRequestModel) -> Single<Result<SignUpResponseModel, NetworkError>> {
        
        return signUpRepository.requestSignUp(requestModel)
    }
}

// UseCase의 역할이 단순 전달만..?
// 텍스트에 대한 유효성 검사도 UseCase에서 할 수 있지 않을까??
