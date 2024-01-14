//
//  ChannelDTO.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation


struct ChannelInfoDTO: Codable {
    let workspace_id: Int
    let channel_id: Int
    let name: String
    let description: String?
    let owner_id: Int
    let privateNum: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case privateNum = "private"
        case workspace_id, channel_id, name, description, owner_id, createdAt
    }
}

extension ChannelInfoDTO {
    func toDomain() -> WorkSpaceChannelInfoModel {
        return .init(
            channelId: channel_id,
            name: name
        )
    }
}


/* ========== 채널 생성 ========== */
struct MakeChannelRequestDTO {
    let workSpaceId: Int
    let channelName: String
    let channelDescription: String?
}
extension MakeChannelRequestDTO {
    init(_ model: MakeChannelRequestModel) {
        self.workSpaceId = model.workSpaceId
        self.channelName = model.channelName
        self.channelDescription = model.channelDescription
    }
}


/* ========== 모든 채널 조회 ========== */
typealias WorkSpaceAllChannelsResponseDTO = [ChannelInfoDTO]

/* ========== 내가 속한 채널 조회 ========== */
typealias MyChannelsResponseDTO = [ChannelInfoDTO]


/* ========== 읽지 않은 채널 채팅 개수 ========== */
struct ChannelUnreadCountRequestDTO: Encodable {
    let workSpaceId: Int
    let channelName: String
    let after: String
    // 특정 날짜 - 일단 생략
}
extension ChannelUnreadCountRequestDTO {
    init(_ model: ChannelUnreadCountRequestModel) {
        self.channelName = model.channelName
        self.workSpaceId = model.workSpaceId
        self.after = model.after
    }
}

struct ChannelUnreadCountResponseDTO: Decodable {
    let channel_id: Int
    let name: String
    let count: Int
}

extension ChannelUnreadCountResponseDTO {
    func toDomain() -> ChannelUnreadCountInfoModel {
        return .init(count: count)
    }
}
