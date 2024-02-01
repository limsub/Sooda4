//
//  DMModel.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import Foundation

struct DMChattingModel {
    let dmId: Int
    let roomId: Int
    let content: String
    let createdAt: String
    let files: [String]
    let user: UserInfoModel
}


// 1. DM 방 조회
// 요청 : workSpaceId: Int
// 응담 : [WorkSpaceDMInfoModel]


// 2. DM 채팅 생성
struct MakeDMChattingRequestModel {
    let roomId: Int
    let workSpaceId: Int
    let content: String
    let files: [FileDataModel]
}
// 응답 : DMChattingModel


// 3. DM 채팅 조회
struct DMChattingRequestModel {
    let partnerUserId: Int
    let workSpaceId: Int
    let cursorDate: String
}
// 응답 : [DMChattingDTO] (- workSpaceId랑 roomId 제외)


// 4. 읽지 않은 DM 채팅 개수
struct DMUnreadCountRequestModel {
    let dmRoomId: Int
    let workSpaceId: Int
    let after: String
}
struct DMUnreadCountInfoModel {
    let count: Int
}

