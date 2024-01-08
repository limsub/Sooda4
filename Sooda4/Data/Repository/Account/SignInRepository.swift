//
//  EmailLoginRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignInRepository: SignInRepositoryProtocol {
    
    func signInRequest(_ requestModel: SignInRequestModel) -> Single<Result<SignInResponseModel, NetworkError>> {
        
        // 1. requestDTO 변환
        let dto = SignInRequestDTO(
            email: requestModel.email,
            password: requestModel.password,
            deviceToken: requestModel.deviceToken
        )
        
        // 2. 요청
        return NetworkManager.shared.request(
            type: SignInResponseDTO.self,
            api: .signInRequest(dto)
        )
        .map { result in
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
