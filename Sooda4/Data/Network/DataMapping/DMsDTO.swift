//
//  DMSDTO.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation


struct DMRoomInfoDTO: Codable {
    let workspace_id: Int
    let room_id: Int
    let createdAt: String
    let user: UserInfoDTO
}

extension DMRoomInfoDTO {
    func toDomain() -> WorkSpaceDMInfoModel {
        return .init(
            roomId: room_id,
            userNickname: user.nickname,
            userProfilImage: user.profileImage
        )
    }
}


struct DMChattingDTO: Decodable {
    let dm_id: Int
    let room_id: Int
    let content: String
    let createdAt: String
    let files: [String]
    let user: UserInfoDTO
}
extension DMChattingDTO {
    func toDomain() -> DMChattingModel {
        return .init(dmId: dm_id, roomId: room_id, content: content, createdAt: createdAt, files: files, user: user.toDomain()
        )
    }
}


/* ========== DM 방 조회 ========== */
// 요청 : workSpaceId: Int
typealias MyDMsResponseDTO = [DMRoomInfoDTO]


/* ========== DM 채팅 생성 ========== */
struct MakeDMChattingRequestDTO {
    let roomId: Int
    let workSpaceId: Int
    
    let content: String?
    let files: [FileDataModel]
}
typealias MakeDMChattingResponseDTO = DMChattingDTO


/* ========== DM 채팅 조회 ========== */
struct DMChattingRequestDTO: Encodable {
    let partnerUserId: Int
    let workSpaceId: Int
    let cursorDate: String
}
extension DMChattingRequestDTO {
    init(_ model: DMChattingRequestModel) {
        self.partnerUserId = model.partnerUserId
        self.workSpaceId = model.workSpaceId
        self.cursorDate = model.cursorDate
    }
}

struct DMChattingResponseDTO {
    let workspace_id: Int
    let room_id: Int
    let chats: [DMChattingDTO]
}


/* =========== 읽지 않은 DM 채팅 개수 ========== */
struct DMUnreadCountRequestDTO: Encodable {
    let dmRoomId: Int
    let workSpaceId: Int
    let after: String
}
extension DMUnreadCountRequestDTO {
    init(_ model: DMUnreadCountRequestModel) {
        self.dmRoomId = model.dmRoomId
        self.workSpaceId = model.workSpaceId
        self.after = model.after
    }
}

struct DMUnreadCountResponseDTO: Decodable {
    let room_id: Int
    let count: Int
}
extension DMUnreadCountResponseDTO {
    func toDomain() -> DMUnreadCountInfoModel {
        return .init(count: count)
    }
}
