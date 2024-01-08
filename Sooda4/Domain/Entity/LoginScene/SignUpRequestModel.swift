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
struct LoginRequestModel {
    let email: String
    let password: String
    let deviceToken: String
}

struct LoginResponseModel {
    let userId: Int
    let nickname: String
    let accessToken: String
    let refreshToken: String
}

