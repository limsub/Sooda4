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
    
    // 0. 서버에 저장된 채널 정보 가져와서 디비 업데이트
    func updateChannelInfo(requestModel: ChannelDetailRequestModel, completion: @escaping () -> Void)
    
    // 1. 디비에 저장된 채팅의 마지막 날짜 조회
    func checkLastDate(requestModel: ChannelDetailFullRequestModel) -> Date?
    
    
    // 2. 특정 날짜 이후 최신까지 모든 데이터 불러서 디비에 저장
    func fetchRecentChatting(
        channelChattingRequestModel: ChannelChattingRequestModel,
        completion: @escaping () -> Void
    )
    
    
    // 3 - 1. 읽은 채팅 30개
    func fetchPreviousData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?, isFirst: Bool) -> [ChattingInfoModel]
    
    
    // 3 - 2. 안읽은 채팅 30개
    func fetchNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChattingInfoModel]
    
    
    // 3 - 3. 안읽은 채팅 모두
    func fetchAllNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChattingInfoModel]

    
    // 4. 채팅 전송
    func makeChatting(_ requestModel: MakeChannelChattingRequestModel) -> Single<Result<ChattingInfoModel, NetworkError>>
    
    
    /* - 소켓 - */
    // 연결
    func openSocket(_ channelId: Int)
    
    // 해제
    func closeSocket()
    
    // 응답
    func receiveSocket(_ channelId: Int, completion: @escaping (ChattingInfoModel)-> Void)
}

class ChannelChattingUseCase: ChannelChattingUseCaseProtocol {
    
    // 1. repo
    let channelInfoRepository: ChannelInfoRepositoryProtocol
    let channelChattingRepository: ChannelChattingRepositoryProtocol
    let socketChannelChattingRepository: SocketChannelChattingRepositoryProtocol
    
    
    // 2. init
    init(
        channelInfoRepository: ChannelInfoRepositoryProtocol,
        channelChattingRepository: ChannelChattingRepositoryProtocol,
        socketChannelChattingRepository: SocketChannelChattingRepositoryProtocol
    ) {
        self.channelInfoRepository = channelInfoRepository
        self.channelChattingRepository = channelChattingRepository
        self.socketChannelChattingRepository = socketChannelChattingRepository
    }
    
    
    // 3. 프로토콜 메서드
    
    // 0. 서버에 저장된 채널 정보 가져와서 디비 업데이트
    func updateChannelInfo(requestModel: ChannelDetailRequestModel, completion: @escaping () -> Void) {
        
        return channelInfoRepository.updateChannelInfo(requestModel, completion: completion)
    }
  
    // 1. 디비에 저장된 채팅의 마지막 날짜 조회
    func checkLastDate(requestModel: ChannelDetailFullRequestModel) -> Date? {
        
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
    
    
    // 3 - 1. 읽은 채팅 30개
    func fetchPreviousData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?, isFirst: Bool) -> [ChattingInfoModel] {
        
        return channelChattingRepository.fetchPreviousData(
            requestModel: requestModel,
            targetDate: targetDate,
            isFirst: isFirst
        )
    }
    
    
    // 3 - 2. 안읽은 채팅 30개
    func fetchNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChattingInfoModel] {
        
        return channelChattingRepository.fetchNextData(
            requestModel: requestModel,
            targetDate: targetDate
        )
    }
    
    
    // 3 - 3. 안읽은 채팅 모두
    func fetchAllNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChattingInfoModel] {
        
        return channelChattingRepository.fetchAllNextData(
            requestModel: requestModel,
            targetDate: targetDate
        )
    }
    
    
    // 4. 채팅 전송
    func makeChatting(_ requestModel: MakeChannelChattingRequestModel) -> Single<Result<ChattingInfoModel, NetworkError>> {
        
        return channelChattingRepository.makeChatting(requestModel)
    }
    
    
    
    /* - 소켓 - */
    // 연결
    func openSocket(_ channelId: Int) {
        print("--- USECASE - OPENSOCKET ---")
        socketChannelChattingRepository.openSocket(channelId)
    }
    
    // 해제
    func closeSocket() {
        print("--- USECASE - CLOSESOCKET ---")
        socketChannelChattingRepository.closeSocket()
    }
    
    // 응답
    func receiveSocket(_ channelId: Int, completion: @escaping (ChattingInfoModel)-> Void) {
        print("--- USECASE - RECEIVESOCKET ---")
        socketChannelChattingRepository.receiveSocket(channelId, completion: completion)
    }
}

