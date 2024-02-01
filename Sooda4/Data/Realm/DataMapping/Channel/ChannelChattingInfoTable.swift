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
    
    @Persisted var channelInfo: ChannelInfoTable?
    @Persisted var userInfo: UserInfoTable? // 채팅을 보낸 사람
    
    @Persisted var content: String
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
}


extension ChannelChattingInfoTable {
    // to Domain
    func toDomain() -> ChattingInfoModel {
        return .init(
            chatId: self.chat_id,
            content: self.content,
            createdAt: self.createdAt,
            files: self.files.map { $0 },
            userId: self.userInfo?.user_id ?? -1, 
            userName: self.userInfo?.user_name ?? "",
            userImage: self.userInfo?.user_image ?? ""
        )
    }
    
    
}
