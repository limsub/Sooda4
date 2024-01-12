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
    
    // 3. 워크스페이스 편집
    // 4. 워크스페이스 관리자 변경
    
    
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void)
    
    func deleteWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<String, NetworkError>) -> Void)

}
