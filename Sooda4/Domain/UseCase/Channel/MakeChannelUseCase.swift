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
    func oneChannelInfoRequest(_ requestModel: ChannelDetailRequestModel) -> Single< Result<OneChannelInfoModel, NetworkError> >
}

class MakeChannelUseCase: MakeChannelUseCaseProtocol {
    
    // 1. repo
    let makeChannelRepository: MakeChannelRepositoryProtocol
    let oneChannelInfoRepository: ChannelSettingRepositoryProtocol
    
    // 2. init
    init(makeChannelRepository: MakeChannelRepositoryProtocol, oneChannelInfoRepository: ChannelSettingRepositoryProtocol) {
        self.makeChannelRepository = makeChannelRepository
        self.oneChannelInfoRepository = oneChannelInfoRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func makeChannelRequest(_ requestModel: MakeChannelRequestModel) -> Single<Result<WorkSpaceChannelInfoModel, NetworkError>> {
        return makeChannelRepository.makeChannelRequest(requestModel)
    }
    
    func oneChannelInfoRequest(_ requestModel: ChannelDetailRequestModel) -> Single<Result<OneChannelInfoModel, NetworkError>> {
        
        return oneChannelInfoRepository.oneChannelInfoRequest(requestModel)
    }
}
