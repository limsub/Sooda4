//
//  DMListReposiroty.swift
//  Sooda4
//
//  Created by 임승섭 on 2/2/24.
//

import Foundation
import RxSwift
import RxCocoa

class DMListRepository {
    
    private let realmManager = RealmManager()
    
    
    // 1. DM 방 조회 네트워크 콜 -> DM 방 배열 리턴 (room id와 상대 유저 정보)
    func fetchDMList(_ workSpaceId: Int) -> Single<Result<[WorkSpaceDMInfoModel], NetworkError> > {
        
        return NetworkManager.shared.request(
            type: MyDMsResponseDTO.self,
            api: .workSpaceDMs(workSpaceId)
        )
        .map { response  in
            switch response {
            case .success(let dtoData):
                let responseModel = dtoData.map { $0.toDomain() }
                return .success(responseModel)
            case .failure(let networkError):
                return .failure(networkError)
            }
        }
    }
    
    
    // 2. DM 방의 마지막 채팅 날짜
    func fetchLastDMChattingDate(roomId: Int) -> Date? {
        
        return realmManager.fetchLastDMChattingDate(roomId: roomId)
    }
    
    
    // 3. DM 방의 마지막 채팅 정보 (1개) (cursorDate 빈값)
    func fetchLastChattingInfo(requestModel: DMChattingRequestModel) -> Single< Result<DMChattingModel, NetworkError> > {
        
        let dto = DMChattingRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: DMChattingResponseDTO.self,
            api: .dmChattings(dto)
        )
        .map { response in
            switch response {
            case .success(let dtoData):
                if let lastChattingInfoDTO = dtoData.chats.last {
                    let lastChattingInfoResponse = lastChattingInfoDTO.toDomain()
                    return .success(lastChattingInfoResponse)
                } else {
                    return .failure(.unknown(message: "hi"))
                }
                
                
            case .failure(let networkError):
                return .failure(networkError)
            }
        }
    }
    
    
    // 4. DM 읽지 않은 채팅 개수
    func fetchUnreadCountChatting(_ requestModel: DMUnreadCountRequestModel) -> Single< Result<DMUnreadCountInfoModel, NetworkError> > {
        
        let dto = DMUnreadCountRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: DMUnreadCountResponseDTO.self,
            api: .dmUnreadCount(dto)
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
