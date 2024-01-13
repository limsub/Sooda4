//
//  MakeWorkSpaceUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MakeWorkSpaceUseCaseProtocol {
    /* === 네트워크 === */
    func makeWorkSpaceRequest(_ requestModel: MakeWorkSpaceRequestModel) -> Single< Result< WorkSpaceModel, NetworkError> >
    func editWorkSpaceRequest(_ requestModel: EditWorkSpaceRequestModel) -> Single< Result<WorkSpaceModel, NetworkError> >
}

class MakeWorkSpaceUseCase: MakeWorkSpaceUseCaseProtocol {
    
    // 1. repo
    let makeWorkSpaceRepository: MakeWorkSpaceRepository
    
    // 2. init
    init(makeWorkSpaceRepository: MakeWorkSpaceRepository) {
        self.makeWorkSpaceRepository = makeWorkSpaceRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func makeWorkSpaceRequest(_ requestModel: MakeWorkSpaceRequestModel) -> Single<Result<WorkSpaceModel, NetworkError>> {
        return makeWorkSpaceRepository.makeWorkSpaceRequest(requestModel)
    }
    
    func editWorkSpaceRequest(_ requestModel: EditWorkSpaceRequestModel) -> Single<Result<WorkSpaceModel, NetworkError>> {
        
        return makeWorkSpaceRepository.editWorkSpaceRequest(requestModel)
    }
}
