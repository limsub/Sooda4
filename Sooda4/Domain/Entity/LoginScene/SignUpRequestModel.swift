//
//  SignUpRequestModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import Foundation

/* === 회원가입 === */
struct SignUpRequestModel {
    let email: String
    let nickname: String
    let phoneNum: String
    let password: String
}

struct SignUpResponseModel {
    let userId: Int
//    let email: String
    let nickname: String
    let profileImage: String?
//    let phoneNum: String?
//    let vendor: String
    let token: Token
}
struct Token {
    let accessToken: String
    let refreshToken: String
}


/* === 로그인 === */
struct EmailLoginRequestModel {
    let email: String
    let password: String
    let deviceToken: String
}

struct EmailLoginResponseModel {
    let userId: Int
    let nickname: String
    let accessToken: String
    let refreshToken: String
}


/* === 카카오 로그인 === */
struct KakaoLoginRequestModel {
    let oauthToken: String
    let deviceToken: String
}
// 응답 모델은 SignUpResponseModel 사용

/* === 애플 로그인 === */
struct AppleLoginRequestModel {
    let idToken: String
    let nickname: String
    let deviceToken: String
}
// 응답 모델은 SignUpResponseModel 사용
