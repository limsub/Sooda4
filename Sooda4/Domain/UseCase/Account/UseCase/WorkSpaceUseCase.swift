//
//  WorkSpaceUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol WorkSpaceUseCaseProtocol {
    /* === 네트워크 === */
    func myWorkSpacesRequest() -> Single< Result<[WorkSpaceModel], NetworkError> >
}

class WorkSpaceUseCase: WorkSpaceUseCaseProtocol {
    
    // 1. repo
    let workSpaceRepository: WorkSpaceRepositoryProtocol
    
    // 2. init (의존성 주입)
    init(workSpaceRepository: WorkSpaceRepositoryProtocol) {
        self.workSpaceRepository = workSpaceRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func myWorkSpacesRequest() -> Single<Result<[WorkSpaceModel], NetworkError>> {
        
        return workSpaceRepository.myWorkSpaceRequest()
    }
}
