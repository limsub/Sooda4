//
//  ChannelSettingRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class ChannelSettingRepository: ChannelSettingRepositoryProtocol {
    
    // 1. 특정 채널 정보 가져오기
        // - 요청 : ChannelDetailRequestModel, DTO
        // - 응답 : OneChannelInfoModel, OneChannelResponseDTO
    func oneChannelInfoRequest(_ requestModel: ChannelDetailRequestModel, completion: @escaping (Result<OneChannelInfoModel, NetworkError>) -> Void) {
        
        let dto = ChannelDetailRequestDTO(requestModel)
        
        NetworkManager.shared.requestCompletion(
            type: OneChannelResponseDTO.self,
            api: .oneChannel(dto)) { response  in
                switch response {
                case .success(let dtoData):
                    let responseModel = dtoData.toDomain()
                    completion(.success(responseModel))
                    
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }
    
    func oneChannelInfoRequest(_ requestModel: ChannelDetailRequestModel) -> Single< Result<OneChannelInfoModel, NetworkError> > {
        
        let dto = ChannelDetailRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: OneChannelResponseDTO.self,
            api: .oneChannel(dto)
        )
        .map { response in
            switch response {
            case .success(let dtoData):
                let responseModel = dtoData.toDomain()
                
                return .success(responseModel)
                
            case .failure(let networkError):
                return .failure(networkError)
            }
        }
        
    }
    
}
