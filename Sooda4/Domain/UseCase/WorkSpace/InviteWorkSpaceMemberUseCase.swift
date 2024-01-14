//
//  InviteWorkSpaceMemberUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation

protocol InviteWorkSpaceMemberUseCaseProtocol {
    /* === 네트워크 === */
    // 이메일 초대
    
    
    
    /* === 로직 === */
    func checkEmailFormat(_ txt: String) -> Bool
}

class InviteWorkSpaceMemberUseCase: InviteWorkSpaceMemberUseCaseProtocol {
    
    
    // 1. repo
    
    // 2. init
    
    // 3. 프로토콜 메서드 (네트워크)
    
    // 4. 프로토콜 메서드 (로직)
    func checkEmailFormat(_ txt: String) -> Bool {
        if txt.contains("@") && txt.contains(".com") { return true }
        else { return false }
    }
}
