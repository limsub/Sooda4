//
//  ChattingInfoModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/22/24.
//

import Foundation

struct ChattingInfoModel {
    let content: String?
    let createdAt: Date
    let files: [String]
    
    let userName: String
    let userImage: String?
}


struct MakeChannelChattingRequestModel {
    let channelName: String
    let workSpaceId: Int
    
    let content: String?
    let files: [Data]
}
