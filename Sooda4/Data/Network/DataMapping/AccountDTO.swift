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

// mapping to Domain
extension SignUpResponseDTO {
    func toDomain() -> SignUpResponseModel {
        return .init(userId: user_id, nickname: nickname, profileImage: profileImage, token: token.toDomain())
    }
}
extension TokenDTO {
    func toDomain() -> Token {
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}


/* ========== 로그인 ========== */
struct SignInRequestDTO: Encodable {
    let email: String
    let password: String
    let deviceToken: String
}

struct SignInResponseDTO: Decodable {
    let user_id: Int
    let nickname: String
    let accessToken: String 
    let refreshToken: String
}

// mapping to Domain
extension SignInResponseDTO {
    func toDomain() -> EmailLoginResponseModel {
        return .init(userId: user_id, nickname: nickname, accessToken: accessToken, refreshToken: refreshToken)
    }
}



/* ========== FCM deviceToken 저장 ========== */
struct DeviceTokenUpdateRequestDTO {
    let deviceToken: String
}
// 응답 No Data



/* =========== 내 프로필 정보 조회 ========== */
struct MyProfileInfoDTO: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String
    let vendor: String?
    let sesacCoin: Int
    let createdAt: String
}

extension MyProfileInfoDTO {
    func toDomain() -> WorkSpaceMyProfileInfoModel {
        // HomeDefaultView에서 사용하는 사용자 정보는 사진밖에 없어
        return .init(profileImage: profileImage)
    }
}
