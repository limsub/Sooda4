//
//  NetworkError.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import Foundation


enum NetworkError: Error {
    // 서버에서 주는 에러가 아닌, 실제 에러(?) 알라모파이어 에러 이런거
    case unknown(message: String)
    
    // 서버에서 주는 에러 종류
    case E03    // (로그인 실패)
    case E11    // 잘못된 요청
    case E12    // 중복 데이터
    case E13    // 존재하지 않는 데이터
    
    case E14    // 권한없음 (관리자 아닌데 삭제하려고 함)
    case E15    // 요청 거절 (채널 관리자)
    
    case E21    // 새싹코인 부족 (워크스페이스 생성)
    
    init(_ error: String) {
        
        switch error {
        case "E03": self = .E03
        case "E11": self = .E11
        case "E12": self = .E12
        case "E15": self = .E15
        case "E21": self = .E21
            
        default: self = .unknown(message: error)
        }
    }
}
