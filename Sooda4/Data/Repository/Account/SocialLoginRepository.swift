//
//  SocialLoginRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 2/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class SocialLoginRepository: SocialLoginRepositoryProtocol {
    
    // 카카오 로그인
    func kakaoLoginRequest(_ requestModel: KakaoLoginRequestModel) -> Single<Result<KakaoLoginResponseModel, NetworkError>> {
        
        let dto = KakaoLoginRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: KakaoLoginResponseDTO.self,
            api: .kakaoLoginRequest(dto)
        )
        .map { response in
            switch response {
            case .success(let dtoData):
                let responseModel = dtoData.toDomain()
                return .success(responseModel)
                
            case .failure(let networkError):
                return .failure(networkError)
            }
        }
    }
    
    
    // 애플 로그인
    func appleLoginRequest(_ requestModel: AppleLoginRequestModel) -> Single<Result<AppleLoginResponseModel, NetworkError>> {
        
        return Single.create { single in
            return single(.failure(NetworkError.unknown(message: "hi"))) as! any Disposable
        }
    }
}
