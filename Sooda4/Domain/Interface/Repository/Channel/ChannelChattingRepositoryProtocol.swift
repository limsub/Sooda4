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
    // 1. 특정 채널의 채팅 조회
    func channelChattingsRequest(_ requestModel: ChannelChattingRequestModel) -> Single< Result< ChannelChattingResponseModel, NetworkError> >
    
    
    // 1. 디비에 저장된 채팅의 마지막 날짜 조회
    func checkLastDate(requestModel: ChannelDetailRequestModel) -> Date?
    
    // 2. 특정 날짜 이후부터 모든 채팅 조회
    func fetchRecentChatting(
        channelChattingRequestModel: ChannelChattingRequestModel,
        completion: @escaping (Result<[ChattingInfoModel], NetworkError>) -> Void
    )
}
