//
//  SocialLoginRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 2/7/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SocialLoginRepositoryProtocol {
    // 카카오 로그인
    func kakaoLoginRequest(_ requestModel: KakaoLoginRequestModel) -> Single< Result< KakaoLoginResponseModel, NetworkError> >
    
    // 애플 로그인
    func appleLoginRequest(_ requestModel: AppleLoginRequestModel) -> Single< Result< AppleLoginResponseModel, NetworkError> >
    
    
}
