//
//  ChannelChattingUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChannelChattingUseCaseProtocol {
    // 네트워크
    func channelChattingRequest(_ requestModel: ChannelChattingRequestModel) -> Single< Result< ChannelChattingResponseModel, NetworkError> >
//    
//    // 디비
//    func checkLastDate() -> Date?
}

class ChannelChattingUseCase: ChannelChattingUseCaseProtocol {
    
    // 1. repo
    let channelChattingRepository: ChannelChattingRepositoryProtocol
    
    // 2. init
    init(channelChattingRepository: ChannelChattingRepositoryProtocol) {
        self.channelChattingRepository = channelChattingRepository
    }
    
    
    // 3. 프로토콜 메서드 (네트워크)
    func channelChattingRequest(_ requestModel: ChannelChattingRequestModel) -> Single<Result<ChannelChattingResponseModel, NetworkError>> {
        
        return channelChattingRepository.channelChattingsRequest(requestModel)
    }
    

}

