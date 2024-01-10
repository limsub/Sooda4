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




/* ========== DM 방 조회 ========== */
typealias MyDMsResponseDTO = [DMRoomInfoDTO]
