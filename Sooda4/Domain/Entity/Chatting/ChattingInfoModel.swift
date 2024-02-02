//
//  ChattingInfoModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/22/24.
//

import Foundation

struct ChannelChattingInfoModel: Decodable {
    let chatId: Int
    
    let content: String?
    let createdAt: Date
    let files: [String]
    
    let userId: Int
    let userName: String
    let userImage: String?
}


struct MakeChannelChattingRequestModel {
    let channelName: String
    let workSpaceId: Int
    
    let content: String?
    let files: [FileDataModel]
}
