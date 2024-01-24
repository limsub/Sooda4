//
//  ChannelInfoTable.swift
//  Sooda4
//
//  Created by 임승섭 on 1/24/24.
//

import Foundation
import RealmSwift

class ChannelInfoTable: Object {
    
    @Persisted(primaryKey: true) var channel_id: Int
    
    @Persisted var workspace_id: Int
    @Persisted var channel_name: String
    
}
