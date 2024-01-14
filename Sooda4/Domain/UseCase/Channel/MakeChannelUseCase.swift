//
//  MakeChannelUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MakeChannelUseCaseProtocol {
    /* === 네트워크 === */
    func makeChannelRequest(_ requestModel: MakeChannelRequestModel) -> Single< Result<WorkSpaceChannelInfoModel, NetworkError> >
}

class MakeChannelUseCase: MakeChannelUseCaseProtocol {
    
    // 1. repo
    let makeChannelRepository: MakeChannelRepositoryProtocol
    
    // 2. init
    init(makeChannelRepository: MakeChannelRepositoryProtocol) {
        self.makeChannelRepository = makeChannelRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func makeChannelRequest(_ requestModel: MakeChannelRequestModel) -> Single<Result<WorkSpaceChannelInfoModel, NetworkError>> {
        return makeChannelRepository.makeChannelRequest(requestModel)
    }
}
