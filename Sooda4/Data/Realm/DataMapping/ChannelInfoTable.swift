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


// TODO: 다른 파일 만들어서 옮기기

class UserInfoTable: Object {
    
    @Persisted(primaryKey: true) var user_id: Int
    
    @Persisted var user_name: String
    @Persisted var user_email: String
    @Persisted var user_image: String?
}

class ChannelChattingInfoTable: Object {
    
    @Persisted(primaryKey: true) var chat_id: Int
    
    @Persisted(originProperty: "channel_id") var channelInfo: LinkingObjects<ChannelInfoTable>
    @Persisted(originProperty: "user_id") var userInfo: LinkingObjects<UserInfoTable>
    
    @Persisted var content: String
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
}
