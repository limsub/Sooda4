//
//  ExploreChannelRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class ExploreChannelRepository: ExploreChannelRepositoryProtocol {
    
    // 1. 모든 채널 조회
    func workSpaceAllChannelsRequest(_ requestModel: Int) -> Single< Result<[WorkSpaceChannelInfoModel], NetworkError> > {
        
        return NetworkManager.shared.request(
            type: WorkSpaceAllChannelsResponseDTO.self,
            api: .workSpaceAllChannels(requestModel)
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
    
    // 2. 특정 채널의 멤버 조회
    func channelMembersRequest(_ requestModel: ChannelDetailRequestModel) -> Single< Result<[WorkSpaceUserInfo], NetworkError> > {
        
        let requestDto = ChannelDetailRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: ChannelMembersResponseDTO.self,
            api: .channelMembers(requestDto)
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
