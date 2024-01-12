//
//  HandleWorkSpaceRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import Foundation

class HandleWorkSpaceRepository: HandleWorkSpaceRepositoryProtocol {
    
    
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void) {
        
        return NetworkManager.shared.requestCompletion(
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
}
