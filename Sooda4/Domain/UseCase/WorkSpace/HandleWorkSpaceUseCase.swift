//
//  HandleWorkSpaceUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import Foundation

protocol HandleWorkSpaceUseCaseProtocol {
    /* === 네트워크 === */
    // workSpaceRepo - 1
    func myWorkSpaceRequest(completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void)
    
    
    // handleWorkSpaceRepo - 1
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void)
    
    // handleWorkSpaceRepo - 2
    func deleteWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<String, NetworkError>) -> Void)
    
    // handleWorkSpaceRepo - 3 - 1
    func workSpaceMembersRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceUserInfo], NetworkError>) -> Void)
    
    func changeAdminWorkSpace(_ requestModel: ChangeAdminRequestModel, completion: @escaping (Result<WorkSpaceModel, NetworkError>) -> Void)
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
    // - 1
    func myWorkSpaceRequest(completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void) {
        
        workSpaceRepository.myWorkSpaceRequest(completion: completion)
    }
    
    
    // - 1
    func leaveWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void) {
        
        handleWorkSpaceRepository.leaveWorkSpaceRequest(
            requestModel, 
            completion: completion
        )
    }
    
    // - 2
    func deleteWorkSpaceRequest(_ requestModel: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        handleWorkSpaceRepository.deleteWorkSpaceRequest(
            requestModel,
            completion: completion
        )
    }
    
    // - 3 - 1
    func workSpaceMembersRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceUserInfo], NetworkError>) -> Void) {
        
        handleWorkSpaceRepository.workSpaceMembersRequest(
            requestModel,
            completion: completion
        )
    }
    
    // - 3 - 2
    func changeAdminWorkSpace(_ requestModel: ChangeAdminRequestModel, completion: @escaping (Result<WorkSpaceModel, NetworkError>) -> Void) {
        
        handleWorkSpaceRepository.changeAdminWorkSpace(
            requestModel,
            completion: completion
        )
    }
}
