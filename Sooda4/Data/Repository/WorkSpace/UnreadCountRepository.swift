//
//  UnreadCountRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation

class UnreadCountRepository: UnreadCountRepositoryProtocol {
    
    
    func channelUnreadCountRequest(_ requestModel: ChannelUnreadCountRequestModel, completion: @escaping (Result<ChannelUnreadCountInfoModel, NetworkError>) -> Void) {
        
        NetworkManager.shared.requestCompletion(
            type: ChannelUnreadCountResponseDTO.self,
            api: .channelUnreadCount(
                ChannelUnreadCountRequestDTO(requestModel))
            ) { response  in
                
                switch response {
                case .success(let dtoData):
                    let responseModel = dtoData.toDomain()
                    completion(.success(responseModel))
                    
                case .failure(let networkError):
                    completion(.failure(networkError))
                    
                }
            }
    }
    
    func dmUnreadCountRequest(_ requestModel: DMUnreadCountRequestModel, completion: @escaping (Result<DMUnreadCountInfoModel, NetworkError>) -> Void) {
        
        NetworkManager.shared.requestCompletion(
            type: DMUnreadCountResponseDTO.self ,
            api: .dmUnreadCount(
                DMUnreadCountRequestDTO(requestModel)
            )) { response  in
                
                switch response {
                case .success(let dtoData):
                    let responseModel = dtoData.toDomain()
                    completion(.success(responseModel))
                    
                case .failure(let networkError):
                    completion(.failure(networkError))
                    
                }
            }
    }
    
    
    
}
