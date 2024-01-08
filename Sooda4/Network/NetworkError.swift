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
    case E11    // 잘못된 요청 (이메일 유효성)
    case E12    // 중복 데이터 (이메일 유효성)
    
    init(_ error: String) {
        
        switch error {
        case "E11": self = .E11
        case "E12": self = .E12
        default: self = .unknown(message: error)
        }
    }
}