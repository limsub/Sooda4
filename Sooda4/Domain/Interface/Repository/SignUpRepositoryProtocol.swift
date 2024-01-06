//
//  SignUpRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpRepositoryProtocol {
    
    // (1). 이메일 유효성 검증
    func checkValidEmail(_ email: String) -> Single< Result<String, Error> >
    
    
    
    
    // (2). 회원가입
}
