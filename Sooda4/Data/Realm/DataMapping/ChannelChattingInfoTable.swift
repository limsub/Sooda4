//
//  ChannelChattingInfoTable.swift
//  Sooda4
//
//  Created by 임승섭 on 1/24/24.
//

import Foundation
import RealmSwift

class ChannelChattingInfoTable: Object {
    
    @Persisted(primaryKey: true) var chat_id: Int
    
//    @Persisted(originProperty: "channel_id") var channelInfo: LinkingObjects<ChannelInfoTable>
    
    @Persisted var channelInfo: ChannelInfoTable
    @Persisted var userInfo: UserInfoTable
    
    @Persisted var content: String
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
}



