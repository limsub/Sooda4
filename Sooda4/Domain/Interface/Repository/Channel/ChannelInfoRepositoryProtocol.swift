//
//  ChannelInfoRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/30/24.
//

import Foundation

protocol ChannelInfoRepositoryProtocol {
    // 1. 채널 정보 조회 -> 디비 업데이트
    func updateChannelInfo(_ requestModel: ChannelDetailRequestModel, completion: @escaping () -> Void)
}
