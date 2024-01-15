//
//  ChannelChattingRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class ChannelChattingRepository: ChannelChattingRepositoryProtocol {
    
    // 1. 특정 채널 채팅 조회
    func channelChattingsRequest(_ requestModel: ChannelChattingRequestModel) -> Single<Result<[ChannelChattingModel], NetworkError>> {
        
        let dto = ChannelChattingRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: ChannelChattingResponseDTO.self,
            api: .channelChattings(dto)
        )
        .map { result in
            switch result {
            case .success(let dtoData):
                let responseModel = dtoData.map { $0.toDomain() }
                return .success(responseModel)
                
            case .failure(let networkError):
                return .failure(networkError)
            }
        }
    }
}
