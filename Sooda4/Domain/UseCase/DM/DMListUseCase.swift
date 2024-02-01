//
//  DMListUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class DMListUseCase {
    
    let repo = DMListRepository()
    
    // DM 방 조회
    // -> realm에서 각 방 room id 채팅 찾아서 마지막 날짜, 마지막 채팅 저장
    // -> 마지막 날짜 가지고 안읽은 채팅 네트워크 통신
    // -> 1. 안읽은 채팅이 없다 -> 업데이트 할 거 없고 unreadCnt = 0
    //    2. 안읽은 채팅이 있다 -> 그 중 마지막 요소로 날짜, 채팅 업데이트. unreadCnt = 배열 개수
    
    func fetchDMList(_ workSpaceId: Int) -> Single<Result<[DMChattingCellInfoModel], NetworkError> > {
        
        return repo.fetchDMList(workSpaceId)
            .map { response in
                switch response {
                case .success(let responseModel):
                    
                case .failure(let networkError):
                    return .failure(networkError)
                }
            }
        
    }

    
}

class DMListRepository {
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
}


class DMChattingRepository {
    
    private let realmManager = RealmManager()
    
    
    //
}
