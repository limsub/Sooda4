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








/* ========== 워크스페이스 생성 ========== */
struct MakeWorkSpaceRequestDTO: Encodable {
    let name: String
    let description: String?
    let image: Data
}


/* ========== 내가 속한 워크스페이스 조회 ========== */
typealias MyWorkSpacesResponseDTO = [WorkSpaceInfoDTO]



/* ========== 내가 속한 워크스페이스 한개 조회 ========== */
struct MyOneWorkSpaceResponseDTO: Decodable {
    let workspace_id: Int
    let name: String
    let description: String?
    let thumbnail: String
    let owner_id: Int
    let createdAt: String
    let channels: [ChannelInfoDTO]
    let workspaceMembers: [UserInfoDTO]
}

struct UserInfoDTO: Codable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}

extension UserInfoDTO {
    func toDomain() -> WorkSpaceUserInfo {
        return .init(userId: user_id, email: email, nickname: nickname, profileImage: profileImage)
    }
}

extension MyOneWorkSpaceResponseDTO {
    func toDomain() -> MyOneWorkSpaceModel {
        return .init(name: name, description: description, thumbnail: thumbnail)
    }
}

// UserInfoDTO은 왜 toDomain이 없냐
// -> 일단 워크스페이스 HomeDefaultView에서 사용자들 정보는 이용을 안해.


/* ========== 워크스페이스 편집 ========== */
struct EditWorkSpaceRequestDTO: Encodable {
    let workSpaceId: Int
    let name: String
    let description: String?
    let image: Data
}
// Response는 WorkSpaceInfoDTO 사용


/* ========== 워크스페이스 멤버 초대 ========== */
struct InviteWorkSpaceMemberRequestDTO {
    let workSpaceId: Int
    let email: String
}
extension InviteWorkSpaceMemberRequestDTO {
    init(_ model: InviteWorkSpaceMemberRequestModel) {
        self.workSpaceId = model.workSpaceId
        self.email = model.email
    }
}
// Responsesms UserInfoDTO 사용


/* ========== 워크스페이스 멤버 조회 ========== */
typealias WorkSpaceMembersResponseDTO = [UserInfoDTO]


/* ========== 워크스페이스 관리자 권한 변경 ========== */
struct ChangeAdminWorkSpaceRequestDTO {
    let id: Int
    let user_id: Int
}
// Response는 WorkSpaceInfoDTO 사용
