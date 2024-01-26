//
//  EmailLoginRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignInRepositoryProtocol {
    // (1). 이메일 로그인
    func signInRequest(_ requestModel: EmailLoginRequestModel) -> Single< Result<EmailLoginResponseModel, NetworkError> >
}
