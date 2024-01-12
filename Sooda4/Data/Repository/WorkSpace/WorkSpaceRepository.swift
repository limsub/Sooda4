//
//  WorkSpaceRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import Foundation
import RxSwift
import RxCocoa

class WorkSpaceRepository: WorkSpaceRepositoryProtocol {
    
    // 1. 내가 속한 워크스페이스 조회 - Single
    func myWorkSpaceRequest() -> Single< Result<[WorkSpaceModel], NetworkError> > {
        
        
        // 1. 파라미터와 쿼리스트링 x
        
        // 2. 요청
        return NetworkManager.shared.request(
            type: MyWorkSpacesResponseDTO.self,
            api: .myWorkSpaces
        )
        .map { result in
            switch result {
            case .success(let dtoData):
                let responseModel = dtoData.map { $0.toDomain() }
                return .success(responseModel)
                
            case .failure(let error):
                return .failure(error)
            }
            
        }
    }
    
    // 2. 내가 속한 워크스페이스 조회 - Completion
    func myWorkSpaceRequest(completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void) {
        
        NetworkManager.shared.requestCompletion(
            type: MyWorkSpacesResponseDTO.self ,
            api: .myWorkSpaces) { response  in
                switch response {
                case .success(let dtoData):
                    let responseModel = dtoData.map { $0.toDomain() }
                    completion(.success(responseModel))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
