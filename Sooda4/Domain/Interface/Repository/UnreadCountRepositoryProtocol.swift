//
//  UnreadCountRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation

protocol UnreadCountRepositoryProtocol {
    // (1). 읽지 않은 채널 채팅 개수 확인 (ChannelUnreadCountInfoModel)
    // (2). 읽지 않은 디엠 채팅 개수 확인 (DMUnreadCountInfoModel)
    
    func channelUnreadCountRequest(_ requestModel: ChannelUnreadCountRequestModel, completion: @escaping (Result<ChannelUnreadCountInfoModel, NetworkError>) -> Void)
    
    func dmUnreadCountRequest(_ requestModel: DMUnreadCountRequestModel, completion: @escaping (Result<DMUnreadCountInfoModel, NetworkError>) -> Void)
}
