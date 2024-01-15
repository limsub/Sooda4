//
//  ChannelSettingUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation

protocol ChannelSettingUseCaseProtocol {
    /* === 네트워크 === */
    func oneChannelInfoRequest(_ requestModel: ChannelDetailRequestModel, completion: @escaping (Result<OneChannelInfoModel, NetworkError>) -> Void)
}


class ChannelSettingUseCase: ChannelSettingUseCaseProtocol {
    
    // 1. repo
    let channelSettingRepository: ChannelSettingRepositoryProtocol
    
    // 2. init
    init(channelSettingRepository: ChannelSettingRepositoryProtocol) {
        self.channelSettingRepository = channelSettingRepository
    }
    
    // 3. 프로토콜 메서드
    func oneChannelInfoRequest(_ requestModel: ChannelDetailRequestModel, completion: @escaping (Result<OneChannelInfoModel, NetworkError>) -> Void) {
        
        channelSettingRepository.oneChannelInfoRequest(requestModel, completion: completion)
    }
    
    
}
