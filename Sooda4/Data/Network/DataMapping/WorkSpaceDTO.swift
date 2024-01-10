//
//  WorkSpaceDTO.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import Foundation

/* ===== 아마 공통? (자주 쓸 것 같은 구조체) ===== */
struct WorkSpaceInfoDTO: Codable {
    let workspace_id: Int
    let name, description, thumbnail: String
    let owner_id: Int
    let createdAt: String
}
extension WorkSpaceInfoDTO {
    func toDomain() -> WorkSpaceModel {
        return .init(workSpaceId: workspace_id, name: name, description: description, thumbnail: thumbnail, ownerId: owner_id, createdAt: createdAt)
    }
}

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

struct UserInfoDTO: Codable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}




/* ========== 워크스페이스 생성 ========== */
struct MakeWorkSpaceRequestDTO: Encodable {
    let name: String
    let description: String?
    let image: Data
}


/* ========== 내가 속한 워크스페이스 조회 ========== */
typealias MyWorkSpacesResponseDTO = [WorkSpaceInfoDTO]



/* ========== 내가 속한 워크스페이스 한개 조회 ========== */
struct MyOneWorkSpaceResponseDTO {
    let workspace_id: Int
    let name: String
    let description: String
    let thumbnail: String
    let owner_id: Int
    let createdAt: String
    let channels: [ChannelInfoDTO]
    let workspaceMembers: [UserInfoDTO]
}

