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

struct ChannelDetailRequestDTO {
    let workSpaceId: Int
    let channelName: String
}
extension ChannelDetailRequestDTO {
    init(_ model: ChannelDetailRequestModel) {
        self.workSpaceId = model.workSpaceId
        self.channelName = model.channelName
    }
}

struct ChannelChattingDTO: Decodable {
    let channel_id: Int
    let channelName: String
    let chat_id: Int
    let content: String?
    let createdAt: String
    let files: [String]
    let user: UserInfoDTO   // user_id, email, nickname, profileImage
}
//extension ChannelChattingDTO {
//    func toDomain() -> ChannelChattingModel {
//        return .init(
//            content: content,
//            files: files,
//            userName: user.nickname,
//            userImage: user.profileImage
//        )
//    }
//}
// * 수정!
extension ChannelChattingDTO {
    func toDomain() -> ChattingInfoModel {
        return .init(
            content: content,
            createdAt: createdAt.toDate(to: .fromAPI)!,
            files: files,
            userName: user.nickname,
            userImage: user.profileImage
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


/* ========== 특정 채널 조회 ========== */
// 요청은 ChannelDetailRequestDTO 사용
struct OneChannelResponseDTO: Decodable {
    let workspace_id: Int
    let channel_id: Int
    let name: String
    let description: String?
    let owner_id: Int
//    let private: Int
    let createdAt: String
    
    let channelMembers: [UserInfoDTO]
}
extension OneChannelResponseDTO {
    func toDomain() -> OneChannelInfoModel {
        return .init(
            channelName: name,
            channelDescription: description,
            ownerId: owner_id,
            users: channelMembers.map { $0.toDomain() }
        )
    }
}


/* ========== 채널 채팅 조회 ========== */
struct ChannelChattingRequestDTO: Encodable {
    let workSpaceId: Int
    let channelName: String
    let cursor_date: String
}
extension ChannelChattingRequestDTO {
    init(_ model: ChannelChattingRequestModel) {
        self.workSpaceId = model.workSpaceId
        self.channelName = model.channelName
        self.cursor_date = model.cursor_date
    }
}
typealias ChannelChattingResponseDTO = [ChannelChattingDTO]




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





/* ========== 채널 멤버 조회 ========== */
// 요청은 ChannelDetailReqeustDTO 사용
typealias ChannelMembersResponseDTO = [UserInfoDTO]



/* ========== 채널 편집 ========== */
struct EditChannelRequestDTO: Encodable {
    let workSpaceId: Int
    let channelName: String
    let newChannelName: String
    let newDescription: String?
}
extension EditChannelRequestDTO {
    init(_ model: EditChannelRequestModel) {
        self.workSpaceId = model.workSpaceId
        self.channelName = model.channelName
        self.newChannelName = model.newChannelName
        self.newDescription = model.newDesciption
    }
}
typealias EditChannelResponseDTO = ChannelInfoDTO


/* ========== 채널 삭제 ========== */
// 요청은 ChannelDetailRequestDTO 사용
// 응답 Empty Response



/* ========== 채널 퇴장 ========== */
// 요청은 ChannelDetailRequestDTO 사용
typealias LeaveChannelResponseDTO = [ChannelInfoDTO]



/* ========== 채널 관리자 권한 변경 ========== */
struct ChangeAdminChannelRequestDTO {
    let workSpaceId: Int
    let nextAdminUserId: Int
    let channelName: String
}
extension ChangeAdminChannelRequestDTO {
    init(_ model: ChangeAdminChannelRequestModel) {
        self.workSpaceId = model.workSpaceId
        self.nextAdminUserId = model.nextAdminUserId
        self.channelName = model.channelName
    }
}
typealias ChangeAdminChannelResponseDTO = ChannelInfoDTO
