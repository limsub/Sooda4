//
//  AccountDTO.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation

/* ========== 이메일 유효성 검사 ========== */
struct CheckEmailValidationRequestDTO: Encodable {
    let email: String
}

struct CheckEmailValidationResponseDTO: Decodable {
    
}

/* ========== 회원가입 ========== */
struct SignUpRequestDTO: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String?
    let deviceToken: String
}

struct SignUpResponseDTO: Decodable {
    let user_id: Int
    let email, nickname: String
    let profileImage: String?       // 아직 타입 모름
    let phone: String?              // 아직 타입 모름
    let vendor: String?             // 아직 타입 모름
    let createdAt: String
    let token: TokenDTO
}
struct TokenDTO: Decodable {
    let accessToken, refreshToken: String
}