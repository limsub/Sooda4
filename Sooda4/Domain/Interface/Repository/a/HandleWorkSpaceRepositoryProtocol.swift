//
//  HandleWorkSpaceRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import Foundation

protocol HandleWorkSpaceRepositoryProtocol {
    // 1. 워크스페이스 나가기
        // - 요청 타입 workSpaceId: Int
        // - 응답 타입 워크스페이스 여러개 조회할 때와 동일
    
    // 2. 워크스페이스 삭제
        // - 요청 타입 workSpaceId: Int
        // - 응답 데이터 없음
    
    // 3 - 1. 워크스페이스 멤버 조회
        // - 요청 타입 workSpaceId: Int
        // - 응답 데이터 [유저들] - WorkSpaceMembersResponseDTO
    
    // 3 - 2. 워크스페이스 관리자 권한 변경
        // - 요청 타입 workSpaceId: Int, userId: Int
        // - 응답 타입 WorkSpaceInfoDTO(domain: WorkSpaceModel) 가져다 쓰기
    
    // 4. 워크스페이스 편집
    
    
    // 1.
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void)
    
    
    // 2.
    func deleteWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<String, NetworkError>) -> Void)

    
    // 3 - 1.
    func workSpaceMembersRequest(_ requestModel: Int, completion: @escaping (Result<[UserInfoModel], NetworkError>) -> Void)
    
    
    // 3 - 2.
    func changeAdminWorkSpace(_ requestModel: ChangeAdminRequestModel, completion: @escaping (Result<WorkSpaceModel, NetworkError>) -> Void)
}
