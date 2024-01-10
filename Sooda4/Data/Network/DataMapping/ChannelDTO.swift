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
    let privateNum: String
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


/* ========== 채널 조회 ========== */
typealias MyChannelsResponseDTO = [ChannelInfoDTO]
