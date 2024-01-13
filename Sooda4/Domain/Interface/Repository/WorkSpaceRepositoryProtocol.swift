//
//  WorkSpaceRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol WorkSpaceRepositoryProtocol {
    
    // (1). 내가 속한 워크스페이스 조회 - Single
    func myWorkSpaceRequest() -> Single< Result<[WorkSpaceModel], NetworkError> >
    
    // (2). 내가 속한 워크스페이스 조회 - Completion
    func myWorkSpaceRequest(completion: @escaping (Result<[WorkSpaceModel], NetworkError>) -> Void)
}
