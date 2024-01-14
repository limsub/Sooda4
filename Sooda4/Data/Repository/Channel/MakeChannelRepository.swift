//
//  MakeChannelRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class MakeChannelRepository: MakeChannelRepositoryProtocol {
    
    // (1). 채널 생성
    func makeChannelRequest(_ requestModel: MakeChannelRequestModel) -> Single<Result<WorkSpaceChannelInfoModel, NetworkError>> {
        
        // 1. dto
        let dto = MakeChannelRequestDTO(requestModel)
        
        // 2. request
        return NetworkManager.shared.request(
            type: ChannelInfoDTO.self,
            api: .makeChannel(dto)
        )
        .map { result in
            switch result {
            case .success(let dtoData):
                let responseModel = dtoData.toDomain()
                return .success(responseModel)
                
            case .failure(let networkError):
                return .failure(networkError)
            }
        }
    }
}
