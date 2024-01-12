//
//  HandleWorkSpaceRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import Foundation

class HandleWorkSpaceRepository: HandleWorkSpaceRepositoryProtocol {
    
    // 1. 워크스페이스 나가기
        // - 요청 : Int (workSpaceId)
        // - 응답 : "내가 속한 워크스페이스 조회" 와 동일
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void) {
        
        NetworkManager.shared.requestCompletion(
            type: MyWorkSpacesResponseDTO.self,  // 응답 타입 동일
            api: .leaveWorkSpace(requestModel)) { response  in
                switch response {
                case .success(let dtoData):
                    let responseModel = dtoData.map { $0.toDomain() }
                    completion(.success(responseModel))
                    
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }
    
    
    // 2. 워크스페이스 삭제
        // - 요청 : Int (workSpaceId)
        // - 응답 : nil
    func deleteWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        NetworkManager.shared.requestCompletionEmptyResponse(
            api: .deleteWorkSpace(requestModel),
            completion: completion
        )
    }
    
}
