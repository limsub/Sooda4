//
//  SignUpRequestModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import Foundation

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
