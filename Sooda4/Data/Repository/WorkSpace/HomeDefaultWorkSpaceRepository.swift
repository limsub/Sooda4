//
//  HomeDefaultWorkSpaceRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation

class HomeDefaultWorkSpaceRepository: MyWorkSpaceRepositoryProtocol {
    
    // 워크스페이스 정보
    func myOneWorkSpaceInfoRequest(_ requestModel: Int, completion: @escaping (Result<MyOneWorkSpaceModel, NetworkError>) -> Void) {
        
        
        NetworkManager.shared.requestCompletion(
            type: MyOneWorkSpaceResponseDTO.self,
            api: .myOneWorkSpace(requestModel)) { response in
                switch response {
                case .success(let dtoData):
                    let responseModel = dtoData.toDomain()
                    completion(.success(responseModel))
                    
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }
    
    
    
    // 워크스페이스 채널들 정보 (내가 속한 모든 채널)
    func workSpaceChannelsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceChannelInfoModel], NetworkError>) -> Void) {
        
        NetworkManager.shared.requestCompletion(
            type: MyChannelsResponseDTO.self,
            api: .workSpaceMyChannels(requestModel)) { response  in
                switch response {
                case .success(let dtoData):
                    let responseModel = dtoData.map { $0.toDomain() }
                    completion(.success(responseModel))
                    
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }
    
    
    
    // 워크스페이스 디엠들 정보
    func workSpaceDMsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceDMInfoModel], NetworkError>) -> Void) {
        
        NetworkManager.shared.requestCompletion(
            type: MyDMsResponseDTO.self ,
            api: .workSpaceDMs(requestModel)) { response  in
                switch response {
                case .success(let dtoData):
                    let responseModel = dtoData.map { $0.toDomain() }
                    completion(.success(responseModel))
                    
                    
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
    }
    
    // 내 프로필 정보
    func workSpaceMyProfileRequest(completion: @escaping (Result<WorkSpaceMyProfileInfoModel, NetworkError>) -> Void) {
        
        NetworkManager.shared.requestCompletion(
            type: MyProfileInfoDTO.self ,
            api: .myProfileInfo) { response  in
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
