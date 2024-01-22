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
    
    func fetchRecentChatting(
        channelChattingRequestModel: ChannelChattingRequestModel,
        completion: @escaping (Result<[ChattingInfoModel], NetworkError>) -> Void
    )
    
    // 디비
    func checkLastDate(requestModel: ChannelDetailRequestModel) -> Date?
    
}

class ChannelChattingUseCase: ChannelChattingUseCaseProtocol {
    
    // 1. repo
    let channelChattingRepository: ChannelChattingRepositoryProtocol
    
    // 2. init
    init(channelChattingRepository: ChannelChattingRepositoryProtocol) {
        self.channelChattingRepository = channelChattingRepository
    }
    
    
    // 3. 프로토콜 메서드 (네트워크)
    // 얘는 더이상 필요 없을듯?
    func channelChattingRequest(_ requestModel: ChannelChattingRequestModel) -> Single<Result<ChannelChattingResponseModel, NetworkError>> {
        
        return channelChattingRepository.channelChattingsRequest(requestModel)
    }
    
    func fetchRecentChatting(
        channelChattingRequestModel: ChannelChattingRequestModel,
        completion: @escaping (Result<[ChattingInfoModel], NetworkError>) -> Void
    ) {
        channelChattingRepository.fetchRecentChatting(
            channelChattingRequestModel: channelChattingRequestModel,
            completion: completion
        )
    }
    

    
    
    func checkLastDate(requestModel: ChannelDetailRequestModel) -> Date? {
        
        return channelChattingRepository.checkLastDate(requestModel: requestModel)
    }
    
    
    

}

