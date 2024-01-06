//
//  SignUpRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpRepository: SignUpRepositoryProtocol {
    
    // 실제로 네트워크 콜을 쏘는 곳
    func checkValidEmail(_ email: String) -> Single< Result<String, Error> > {
        
        // 1. requestDTO 변환
        let dto = CheckEmailValidationRequestDTO(
            email: email
        )
        
        // 2. 요청
        return NetworkManager.shared.requestEmptyResponse(api: .checkValidEmail(dto))
    }
}
