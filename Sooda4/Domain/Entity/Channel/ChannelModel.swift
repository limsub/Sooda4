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


// 채널 채팅 조회
struct ChannelChattingRequestModel {
    let workSpaceId: Int
    let channelName: String
    let cursor_date: String
}
struct ChannelChattingModel {
    let content: String?
    let files: [String]
    let userName: String
    let userImage: String?
}
typealias ChannelChattingResponseModel = [ChannelChattingModel]


// 채널 정보 조회 (ChannelSettingView)
struct OneChannelInfoModel {
    let channelName: String
    let channelDescription: String?
    let ownerId: Int
    
    let users: [WorkSpaceUserInfo]
}


/* ========== 1. 채널 편집 ========== */
struct EditChannelRequestModel {
    let workSpaceId: Int
    let channelName: String
    let newChannelName: String
    let newDesciption: String?
}
// 응답은 WorkSpaceChannelInfoModel



/* ========== 2. 채널 퇴장 ========== */
// 요청 ChannelDetailRequestModel
// 응답 [WorkSpaceChannelInfoModel]


/* ========== 3 - 1. 채널 멤버 조회 ========== */
// 요청 ChannelDetailRequestModel
// 응답 [WorkSpaceUserInfo]


/* ========== 3 - 2. 채널 관리자 권한 변경 ========== */
struct ChangeAdminChannelRequestModel {
    let workSpaceId: Int
    let nextAdminUserId: Int
    let channelName: String
}
// 응답 WorkSpaceChannelInfoModel


/* ========== 4. 채널 삭제 ========== */
// 요청 ChannelDetailRequestModel
// 응답 No response
