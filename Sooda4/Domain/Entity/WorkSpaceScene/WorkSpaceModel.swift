//
//  WorkSpaceModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import Foundation

struct WorkSpaceModel {
    let workSpaceId: Int
    let name: String
    let description: String
    let thumbnail: String
    let ownerId: Int
    let createdAt: String 
}


// 워크스페이스 생성
struct MakeWorkSpaceRequestModel {
    let name: String
    let description: String
    let image: Data // UIImage
}


/* HomeDefaultView에 띄워줄 데이터 */
// 필요한 데이터만 저장하자!
struct MyOneWorkSpaceModel {
    let name: String
    let thumbnail: String
}
struct WorkSpaceChannelInfoModel {
    let channelId: Int
    let name: String
}
struct WorkSpaceDMInfoModel {
    let roomId: Int
    let userNickname: String
    let userProfilImage: String?
}
struct WorkSpaceMyProfileInfoModel {
    let profileImage: String?
}


// 읽지 않은 채팅 개수
struct ChannelUnreadCountRequestModel {
    let workSpaceId: Int
    let channelName: String
    // 특정 날짜 -> 일단 생략
}
struct DMUnreadCountRequestModel {
    let dmRoomId: Int
    let workSpaceId: Int
}

struct ChannelUnreadCountInfoModel {
    let count: Int
}

struct DMUnreadCountInfoModel {
    let count: Int
}