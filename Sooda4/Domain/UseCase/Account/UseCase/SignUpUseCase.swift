//
//  SignUpUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpUseCase: SignUpUseCaseProtocol {
    
    // 1. repo
    let signUpRepository: SignUpRepositoryProtocol?
    
    
    // 2. init (의존성 주입)
    init(signUpRepository: SignUpRepositoryProtocol?) {
        self.signUpRepository = signUpRepository
    }
    
    
    // 3. 프로토콜 메서드
    // (1). 이메일 유효성 검증
    func checkValidEmail(_ email: String) -> Single< Result<String, NetworkError> > {
        
        return signUpRepository!.checkValidEmail(email)
        
    }
    
    
}
