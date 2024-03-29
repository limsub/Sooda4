//
//  ChannelChattingRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChannelChattingRepositoryProtocol {
    
    // 1. 디비에 저장된 채팅의 마지막 날짜 조회
    func checkLastDate(requestModel: ChannelDetailFullRequestModel) -> Date?
    
    // 2. 특정 날짜 이후 최신까지 모든 데이터 불러서 디비에 저장
    // - 네트워크 통신 완료 시점 때문에 completion 사용
    func fetchRecentChatting(
        channelChattingRequestModel: ChannelChattingRequestModel,
        completion: @escaping () -> Void
    )
    
    // 3 - 1. 읽은 채팅
    func fetchPreviousData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?, isFirst: Bool) -> [ChannelChattingInfoModel]

    // 3 - 2. 안읽은 채팅
    func fetchNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChannelChattingInfoModel]
    
    // 3 - 3. 안읽은 채팅 모두
    func fetchAllNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChannelChattingInfoModel]
    
    // 4. 채팅 전송
    func makeChatting(_ requestModel: MakeChannelChattingRequestModel) -> Single< Result<ChannelChattingInfoModel, NetworkError> >
    
    
    
}
