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
    // 1. 디비에 저장된 채팅의 마지막 날짜 조회
    func checkLastDate(requestModel: ChannelDetailRequestModel) -> Date?
    
    
    // 2. 특정 날짜 이후 최신까지 모든 데이터 불러서 디비에 저장
    func fetchRecentChatting(
        channelChattingRequestModel: ChannelChattingRequestModel,
        completion: @escaping () -> Void
    )
    
    
    // 3 - 1. 읽은 채팅
    func fetchPreviousData(workSpaceId: Int, channelName: String, targetDate: Date?) -> [ChattingInfoModel]
    
    
    // 3 - 2. 안읽은 채팅
    func fetchNextData(workSpaceId: Int, channelName: String, targetDate: Date?) -> [ChattingInfoModel]

    
    // 4. 채팅 전송
    func makeChatting(_ requestModel: MakeChannelChattingRequestModel) -> Single<Result<ChattingInfoModel, NetworkError>>
    
}

class ChannelChattingUseCase: ChannelChattingUseCaseProtocol {
    
    // 1. repo
    let channelChattingRepository: ChannelChattingRepositoryProtocol
    
    // 2. init
    init(channelChattingRepository: ChannelChattingRepositoryProtocol) {
        self.channelChattingRepository = channelChattingRepository
    }
    
    
    // 3. 프로토콜 메서드
  
    // 1. 디비에 저장된 채팅의 마지막 날짜 조회
    func checkLastDate(requestModel: ChannelDetailRequestModel) -> Date? {
        
        return channelChattingRepository.checkLastDate(requestModel: requestModel)
    }
    
    
    // 2. 특정 날짜 이후 최신까지 모든 데이터 불러서 디비에 저장
    // - 네트워크 통신 완료 시점 때문에 completion 사용
    func fetchRecentChatting(
        channelChattingRequestModel: ChannelChattingRequestModel,
        completion: @escaping () -> Void
    ) {
        
        return channelChattingRepository.fetchRecentChatting(
            channelChattingRequestModel: channelChattingRequestModel,
            completion: completion)
    }
    
    
    // 3 - 1. 읽은 채팅
    func fetchPreviousData(workSpaceId: Int, channelName: String, targetDate: Date?) -> [ChattingInfoModel] {
        
        return channelChattingRepository.fetchPreviousData(
            workSpaceId: workSpaceId,
            channelName: channelName,
            targetDate: targetDate
        )
    }
    
    
    // 3 - 2. 안읽은 채팅
    func fetchNextData(workSpaceId: Int, channelName: String, targetDate: Date?) -> [ChattingInfoModel] {
        
        return channelChattingRepository.fetchNextData(
            workSpaceId: workSpaceId,
            channelName: channelName,
            targetDate: targetDate
        )
    }
    
    
    // 4. 채팅 전송
    func makeChatting(_ requestModel: MakeChannelChattingRequestModel) -> Single<Result<ChattingInfoModel, NetworkError>> {
        
        return channelChattingRepository.makeChatting(requestModel)
    }
}

