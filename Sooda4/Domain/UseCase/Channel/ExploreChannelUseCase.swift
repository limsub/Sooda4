//
//  ExploreChannelUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ExploreChannelUseCaseProtocol {
    /* === 네트워크 === */
    func allChannelRequest(_ requestModel: Int) -> Single< Result<[WorkSpaceChannelInfoModel], NetworkError> >
}


class ExploreChannelUseCase: ExploreChannelUseCaseProtocol {
    
    // 1. repo
    let exploreChannelRepository: ExploreChannelRepositoryProtocol
    
    // 2. init
    init(exploreChannelRepository: ExploreChannelRepositoryProtocol) {
        self.exploreChannelRepository = exploreChannelRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func allChannelRequest(_ requestModel: Int) -> Single<Result<[WorkSpaceChannelInfoModel], NetworkError>> {
        
        return exploreChannelRepository.workSpaceAllChannelsRequest(requestModel)
    }
    
}
