//
//  DMChattingInfoTable.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import Foundation
import RealmSwift

class DMChattingInfoTable: Object {
    
    @Persisted(primaryKey: true) var dm_id: Int
    
    @Persisted var dmInfo: DMInfoTable?
    @Persisted var userInfo: UserInfoTable? // 채팅을 보낸 사람
    
    @Persisted var content: String
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
}

extension DMChattingInfoTable {
    
    // to Domain
//    func toDomain()
}
