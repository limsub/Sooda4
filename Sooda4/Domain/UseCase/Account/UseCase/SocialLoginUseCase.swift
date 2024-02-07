//
//  SocialLoginUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 2/7/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SocialLoginUseCaseProtocol {
    
    // 카카오 로그인
    func kakaoLoginRequest(_ requestModel: KakaoLoginRequestModel) -> Single<Result<KakaoLoginResponseModel, NetworkError>>
    
    
    // 애플 로그인
    func appleLoginRequest(_ requestModel: AppleLoginRequestModel) -> Single<Result<AppleLoginResponseModel, NetworkError>>
}

class SocialLoginUseCase: SocialLoginUseCaseProtocol {
    
    // 1. repo
    let socialLoginRepository: SocialLoginRepositoryProtocol
    
    // 2. init
    init(socialLoginRepository: SocialLoginRepositoryProtocol) {
        self.socialLoginRepository = socialLoginRepository
    }
    
    // 3. 프로토콜 메서드
    func kakaoLoginRequest(_ requestModel: KakaoLoginRequestModel) -> Single<Result<KakaoLoginResponseModel, NetworkError>> {
        return socialLoginRepository.kakaoLoginRequest(requestModel)
    }
    
    func appleLoginRequest(_ requestModel: AppleLoginRequestModel) -> Single<Result<AppleLoginResponseModel, NetworkError>> {
        return socialLoginRepository.appleLoginRequest(requestModel)
    }
    
}
