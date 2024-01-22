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
    
    @Persisted(primaryKey: true) var chatId: Int
    
    
}
