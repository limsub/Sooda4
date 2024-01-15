//
//  KeychainStorage.swift
//  Sooda4
//
//  Created by 임승섭 on 1/16/24.
//

import Foundation
import SwiftKeychainWrapper

private struct KeychainTokens {
    static let accessTokenKey: String = "Sub.AccessToken.Key"
    static let refreshTokenKey: String = "Sub.RefreshToken.Key"
    static let userIdKey: String = "Sub.UserID.Key"
}

final class KeychainStorage {
    
    static let shared = KeychainStorage()
    private init() { }
    
    
    var accessToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainTokens.accessTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainTokens.accessTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainTokens.accessTokenKey)
            }
        }
    }
    
    
    var refreshToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainTokens.refreshTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainTokens.refreshTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainTokens.refreshTokenKey)
            }
        }
    }
    
    
    var _id: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainTokens.userIdKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainTokens.userIdKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainTokens.userIdKey)
            }
        }
    }
    
    func removeAllKeys() {
        KeychainWrapper.standard.removeAllKeys()
    }
    
    func printTokens() {
        let accessToken = accessToken ?? "저장된 엑세스 토큰이 없습니다"
        let refreshToken = refreshToken ?? "저장된 리프레시 토큰이 없습니다"
        let userId = _id ?? "저장된 유저 아이디가 없습니다"
        
        print("엑세스 토큰 : \(accessToken)")
        print("리프레시 토큰 : \(refreshToken)")
        print("유저 아이디 : \(userId)")
    }
}
