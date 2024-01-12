//
//  HandleWorkSpaceUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import Foundation

protocol HandleWorkSpaceUseCaseProtocol {
    /* === 네트워크 === */
    func myWorkSpaceRequest(completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void)
    
    
    
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void)
    
    func deleteWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<String, NetworkError>) -> Void)
}

class HandleWorkSpaceUseCase: HandleWorkSpaceUseCaseProtocol {
    
    // 1. repo
    let handleWorkSpaceRepository: HandleWorkSpaceRepositoryProtocol
    let workSpaceRepository: WorkSpaceRepositoryProtocol
    
    // 2. init (의존성 주입)
    init(
        handleWorkSpaceRepository: HandleWorkSpaceRepositoryProtocol,
        workSpaceRepository: WorkSpaceRepositoryProtocol
    ) {
        self.handleWorkSpaceRepository = handleWorkSpaceRepository
        self.workSpaceRepository = workSpaceRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func myWorkSpaceRequest(completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void) {
        
        workSpaceRepository.myWorkSpaceRequest(completion: completion)
    }
    
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void) {
        
        handleWorkSpaceRepository.leaveWorkSpaceRequest(requestModel, completion: completion)
    }
    
    func deleteWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        handleWorkSpaceRepository.deleteWorkSpaceRequest(requestModel, completion: completion)
    }
}
