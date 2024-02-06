//
//  UserDefaultsManager.swift
//  Sooda4
//
//  Created by 임승섭 on 1/29/24.
//

import Foundation


@propertyWrapper
struct MyDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get  {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


enum UserDefaultsManager {
    enum Key: String {
        case latestChannelChattingId    // 이건 사실상 실패 (멀티 디바이스)
        
        // 현재 보고있는 채팅방
        case currentChannelID
        case currentDMOpponentID
    }
    
    @MyDefault(key: Key.latestChannelChattingId.rawValue, defaultValue: -1)
    static var latestChannelChattingId
    
    @MyDefault(key: Key.currentChannelID.rawValue, defaultValue: -1)
    static var currentChannelID
    
    @MyDefault(key: Key.currentDMOpponentID.rawValue, defaultValue: -1)
    static var currentDMOpponentID
}
