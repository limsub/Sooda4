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

extension ChannelInfoTable {
    
    // from network
    convenience init(_ model: ChannelChattingDTO, workSpaceId: Int) {
        self.init()
        
        self.channel_id = model.channel_id
        self.channel_name = model.channelName
        self.workspace_id = workSpaceId
    }
}
