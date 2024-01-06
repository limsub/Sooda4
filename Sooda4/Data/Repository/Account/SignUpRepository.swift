//
//  SignUpRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation

class SignUpRepository: SignUpRepositoryProtocol {
    
    // 실제로 네트워크 콜을 쏘는 곳은 여기다.
    
    
    func checkValidEmail(_ email: String) {
        
        // 1. requestDTO 변환
        let dto = CheckEmailValidationRequestDTO(
            email: email
        )
        
        // 2. 요청
        
    }
}
