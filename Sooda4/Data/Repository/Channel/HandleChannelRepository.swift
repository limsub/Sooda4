//
//  HandleChannelRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/17/24.
//

import Foundation
import RxSwift
import RxCocoa




class HandleChannelRepository: HandleChannelRepositoryProtocol {
    
    // 1. 채널 편집
        // (DTO)
        // - 요청 : EditChannelRequestDTO
        // - 응답 : EditChannelResponseDTO
    
        // (MODEL)
        // - 요청 : EditChannelRequestModel
        // - 응답 : WorkSpaceChannelInfoModel
    
    
    // 2. 채널 나가기
        // (DTO)
        // - 요청 : ChannelDetailRequestDTO
        // - 응답 : LeaveChannelResponseDTO
    
        // (MODEL)
        // - 요청 : ChannelDetailRequestModel
        // - 응답 : [WorkSpaceChannelInfoModel]

    
    // 3 - 1. 채널 멤버 조회
        // (DTO)
        // - 요청 : ChannelDetailRequestDTO
        // - 응답 : ChannelMembersResponseDTO
    
        // (MODEL)
        // - 요청 : ChannelDetailRequestModel
        // - 응답 : [WorkSpaceUserInfo]
    
    
    // 3 - 2. 채널 관리자 권한 변경
        // (DTO)
        // - 요청 : ChangeAdminChannelRequestDTO
        // - 응답 : ChangeAdminChannelResponseDTO
    
        // (MODEL)
        // - 요청 : ChangeAdminChannelRequestModel
        // - 응답 : WorkSpaceChannelInfoModel

    
    // 4. 채널 삭제
        // (DTO)
        // - 요청 : ChannelDetailRequestDTO
        // - 응답 : No Response
    
        // (MODEL)
        // - 요청 : ChannelDetailRequestModel
        // - 응답 : No response

    
    // 1. 채널 편집
    func editChannelRequest(_ requestModel: EditChannelRequestModel) -> RxSwift.Single<Result<WorkSpaceChannelInfoModel, NetworkError>> {
        
        let dto = EditChannelRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: EditChannelResponseDTO.self,
            api: .editChannel(dto)
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
    
    
    // 2. 채널 나가기
    func leaveChannelRequest(_ requestModel: ChannelDetailRequestModel) -> RxSwift.Single<Result<[WorkSpaceChannelInfoModel], NetworkError>> {
        
        let dto = ChannelDetailRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: LeaveChannelResponseDTO.self,
            api: .leaveChannel(dto)
        )
        .map { response in
            switch response {
            case .success(let dtoData):
                let responseModel = dtoData.map { $0.toDomain() }
                return .success(responseModel)
                
            case .failure(let networkError):
                return .failure(networkError)
            }
        }
    }
    
    
    // 3 - 1. 채널 멤버 조회
    func channelMembersRequest(_ requestModel: ChannelDetailRequestModel) -> RxSwift.Single<Result<[WorkSpaceUserInfo], NetworkError>> {
        
        let dto = ChannelDetailRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: ChannelMembersResponseDTO.self,
            api: .channelMembers(dto)
        )
        .map { response in
            switch response {
            case .success(let dtoData):
                let responseModel = dtoData.map { $0.toDomain() }
                return .success(responseModel)
                
            case .failure(let networkError):
                return .failure(networkError)
                
            }
        }
    }
    
    
    // 3 - 2. 채널 관리자 권한 변경
    func changeAdminChannelRequest(_ requestModel: ChangeAdminChannelRequestModel) -> RxSwift.Single<Result<WorkSpaceChannelInfoModel, NetworkError>> {
        
        let dto = ChangeAdminChannelRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: ChangeAdminChannelResponseDTO.self,
            api: .changeAdminChannel(dto)
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
    
    
    // 4. 채널 삭제
    func deleteChannelRequest(_ requestModel: ChannelDetailRequestModel) -> RxSwift.Single<Result<String, NetworkError>> {
        
        let dto = ChannelDetailRequestDTO(requestModel)
        
        return NetworkManager.shared.requestEmptyResponse(
            api: .deleteChannel(dto)
        )
        
    }
    
    
}
