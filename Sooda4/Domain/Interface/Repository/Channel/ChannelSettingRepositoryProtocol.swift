//
//  ChannelSettingRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation

protocol ChannelSettingRepositoryProtocol {
    
    // 1. 특정 채널 정보 가져오기 (멤버 정보 포함)
    func oneChannelInfoRequest(_ requestModel: ChannelDetailRequestModel, completion: @escaping (Result<OneChannelInfoModel, NetworkError>) -> Void)
}
