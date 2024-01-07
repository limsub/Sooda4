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
    
    // 1. 이메일 유효성 검증
    func checkValidEmail(_ email: String) -> Single< Result<String, NetworkError> > {
        
        // 1. requestDTO 변환
        let dto = CheckEmailValidationRequestDTO(
            email: email
        )
        
        // 2. 요청
        return NetworkManager.shared.requestEmptyResponse(api: .checkValidEmail(dto))
    }
    
    
    // 2. 회원가입
    func requestSignUp(_ requestModel: SignUpRequestModel) -> Single<Result<SignUpResponseModel, NetworkError>> {
        
        // 1. requestDTO 변환
        let dto = SignUpRequestDTO(
            email: requestModel.email,
            password: requestModel.password,
            nickname: requestModel.nickname,
            phone: requestModel.phoneNum,
            deviceToken: "hi"
        )
        
        // 2. 요청
        return NetworkManager.shared.request(
            type: SignUpResponseDTO.self,
            api: .requestSignUp(dto)
        )
        .map { result in
            // DTO 타입을 쓰지 않고, domain layer의 타입을 사용하자
            switch result {
            case .success(let dtoData):
                let responseModel = dtoData.toDomain()
                return .success(responseModel)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
}
