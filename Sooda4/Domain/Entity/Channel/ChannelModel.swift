//
//  ChannelModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation

//struct ChannelModel {
//    let workSpaceId: Int
//    let channelId: Int
//    let name: String
//    let description: String
//    let ownerId: Int
//    let privateNum: Int // 앤 뭔지를 모르겄어
//    let createdAt: String
//}

struct WorkSpaceChannelInfoModel {
    let channelId: Int
    let name: String
}

// path로 workspaceId랑 channel name 있는 것들
struct ChannelDetailRequestModel {
    let workSpaceId: Int
    let channelName: String 
}

// 채널 생성
struct MakeChannelRequestModel {
    let workSpaceId: Int
    let channelName: String
    let channelDescription: String? // 근데 아마 orEmpty로 가져오기 때문에 무조건 스트링이 들어가긴 할거야.... 어떡해야 할라나.. 음
}
// 응답은 WorkSpaceChannelInfoModel (<- ChnnelInfoDTO)
