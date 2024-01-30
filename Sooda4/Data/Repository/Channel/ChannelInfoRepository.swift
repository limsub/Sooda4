//
//  ChannelInfoRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/30/24.
//

import Foundation

class ChannelInfoRepository: ChannelInfoRepositoryProtocol {
    
    private let realmManager = RealmManager()
    
    // 1. 채널 정보 조회 -> 디비 업데이트
    func updateChannelInfo(_ requestModel: ChannelDetailRequestModel, completion: @escaping () -> Void) {
        
        let requestDTO = ChannelDetailRequestDTO(requestModel)
        
        NetworkManager.shared.requestCompletion(
            type: OneChannelResponseDTO.self,
            api: .oneChannel(requestDTO)) { response in
                switch response {
                case .success(let dtoData):
                    self.realmManager.updateChannelInfo(dtoData: dtoData)
                    
                case .failure(let networkError):
                    print("networkError : \(networkError)")
                }
            }
        
    }
}
