//
//  ChattingInfoTable.swift
//  Sooda4
//
//  Created by 임승섭 on 1/22/24.
//

import Foundation
import RealmSwift

/*
 {
     "channel_id": 203,
     "channelName": "Abcd",
     "chat_id": 27,
     "content": "11시 28분에 보내는 채팅",
     "createdAt": "2024-01-22T11:28:59.124Z",
     "files": [],
     "user": {
       "user_id": 44,
       "email": "B@b.com",
       "nickname": "B입니당",
       "profileImage": null
     }
   },
 */

class ChattingInfoTable: Object {
    
    @Persisted var workSpaceId: Int
    
    @Persisted var channelId: Int
    @Persisted var channelName: String
    @Persisted(primaryKey: true) var chatId: Int
    @Persisted var content: String?
    @Persisted var createdAt: Date
    @Persisted var files: List<String>
    
    @Persisted var userId: Int
    @Persisted var userEmail: String
    @Persisted var userNickname: String
    @Persisted var userProfileImage: String?
}


extension ChattingInfoTable {
    // to Domain
    func toDomain() -> ChattingInfoModel {
        return .init(
            content: content,
            createdAt: createdAt,
            files: files.map { $0 },
            userName: userNickname,
            userImage: userProfileImage
        )
    }
    
    
    
    // from Network
    convenience init(_ dto: ChannelChattingDTO, workSpaceId: Int) {
        self.init()
        
        self.workSpaceId = workSpaceId  // 따로 넣어주어야 한다!
        
        self.channelId = dto.channel_id
        self.channelName = dto.channelName
        self.chatId = dto.chat_id
        self.content = dto.content
        self.createdAt = dto.createdAt.toDate(to: .fromAPI)!
        var fileList = List<String>()
        fileList.append(objectsIn: dto.files)
        self.files = fileList
        
        self.userId = dto.user.user_id
        self.userEmail = dto.user.email
        self.userNickname = dto.user.nickname
        self.userProfileImage = dto.user.profileImage
    }
}
