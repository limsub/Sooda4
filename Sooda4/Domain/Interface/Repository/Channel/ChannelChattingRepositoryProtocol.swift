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
}
