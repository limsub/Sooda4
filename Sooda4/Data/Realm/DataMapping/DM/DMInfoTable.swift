//
//  DMInfoTable.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import Foundation
import RealmSwift

class DMRoomInfoTable: Object {
    
    @Persisted(primaryKey: true) var room_id: Int
    
    @Persisted var workspace_id: Int
}

extension DMRoomInfoTable {
    
    // from network
    convenience init(_ model: DMChattingDTO, workSpaceId: Int) {
        self.init()
        
        self.room_id = model.room_id
        self.workspace_id = workSpaceId
    }
}
