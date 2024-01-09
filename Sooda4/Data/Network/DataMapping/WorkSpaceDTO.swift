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


