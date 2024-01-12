//
//  HandleWorkSpaceUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import Foundation

protocol HandleWorkSpaceUseCaseProtocol {
    /* === 네트워크 === */
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void)
}

class HandleWorkSpaceUseCase: HandleWorkSpaceUseCaseProtocol {
    
    // 1. repo
    let handleWorkSpaceRepository: HandleWorkSpaceRepositoryProtocol
    
    // 2. init (의존성 주입)
    init(handleWorkSpaceRepository: HandleWorkSpaceRepositoryProtocol) {
        self.handleWorkSpaceRepository = handleWorkSpaceRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void) {
        
        handleWorkSpaceRepository.leaveWorkSpaceRequest(requestModel, completion: completion)
    }
}