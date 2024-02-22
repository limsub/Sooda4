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
    
    var disposeBag = DisposeBag()
    
    // DM 방 조회
    // -> realm에서 각 방 room id 채팅 찾아서 마지막 날짜, 마지막 채팅 저장
    // -> 마지막 날짜 가지고 안읽은 채팅 네트워크 통신
    // -> 1. 안읽은 채팅이 없다 -> 업데이트 할 거 없고 unreadCnt = 0
    //    2. 안읽은 채팅이 있다 -> 그 중 마지막 요소로 날짜, 채팅 업데이트. unreadCnt = 배열 개수
    
    
    /* --- 수정 후 --- */
    // 1. (API) DM 방 리스트 조회
    // 2. (API) 각 방 별로 마지막 채팅 정보 조회 (realm 사용 x)
    // 3. (Realm + API) 각 방 별 읽지 않은 채팅 개수 조회
    
    func fetchDMList(_ workSpaceId: Int) -> Single<Result<[DMChattingCellInfoModel], NetworkError> > {
        
        return repo.fetchDMList(workSpaceId)  // -> Single<Result<[WorkSpaceDMInfoModel], NetworkError> >
        
            .flatMap { result /*result -> Single< Result<[DMChattingCellInfoModel], NetworkError> >*/ in
                
                switch result { // Result<[WorkSpaceDMInfoModel], NetworkError>
                    
                case .success(let dmInfoArr):
                    
                    // [PrimitiveSequence<SingleTrait, Result<DMChattingCellInfoModel, NetworkError>>]
                    let singleArr: [Single< Result< DMChattingCellInfoModel, NetworkError > >] = dmInfoArr.map { dmInfo in
                        
                        let requestModel = DMChattingRequestModel(
                            partnerUserId: dmInfo.userId,   // 상대방 정보
                            workSpaceId: workSpaceId,
                            cursorDate: ""  // 모든 채팅을 불러오기 때문에 커서 X
                        )
                        
                        return self.repo.fetchLastChattingInfo(
                            requestModel: requestModel
                        )
                        .flatMap { lastChatInfoResult /*lastChatInfoResult -> Single< Result< DMChattingCellInfoModel, NetworkError> >*/ in
                            
                            switch lastChatInfoResult { // Result<DMChattingModel, NetworkError>
                            case .success(let lastChatInfo):    // 마지막 채팅 정보
                                
                                // 디비에 저장된 마지막 채팅 날짜
                                let lastChattingDate = self.repo.fetchLastDMChattingDate(roomId: dmInfo.roomId) ?? Date()
                                
                                print("room id : \(dmInfo.roomId)")
                                print("lastChattingDate : \(lastChattingDate.toString(of: .toAPI))")
                                

                                let modifiedLastChattingDate = Calendar.current.date(byAdding: .hour, value: 9, to: lastChattingDate)!
                                print("+ 9 hours : \(modifiedLastChattingDate.toString(of: .toAPI))")
                                
                                // 디비 날짜 기준으로 요청 -> 읽지 않은 채팅 개수 요청
                                let requestModel = DMUnreadCountRequestModel(
                                    dmRoomId: lastChatInfo.roomId,
                                    workSpaceId: workSpaceId,
                                    after: modifiedLastChattingDate.toString(of: .toAPI)
                                )
                                
                                return self.repo.fetchUnreadCountChatting(requestModel)
                                    .map { unreadCountResult -> Result<DMChattingCellInfoModel, NetworkError> in
                                        
                                        switch unreadCountResult {
                                        case .success(let unreadCountInfo):
                                            let ansModel = DMChattingCellInfoModel(
                                                roomId: dmInfo.roomId,
                                                userInfo: UserInfoModel(
                                                    userId: dmInfo.userId,
                                                    email: "이메일이 없어유ㅠ",
                                                    nickname: dmInfo.userNickname,
                                                    profileImage: dmInfo.userProfilImage
                                                ), // 사고... 따로 저장하고 있다 이메일이 없음;;...,
                                                lastContent: lastChatInfo.content,
                                                lastDate: lastChatInfo.createdAt,
                                                unreadCount: unreadCountInfo.count > 0 ?  unreadCountInfo.count : 0
                                                // 얘도 역시 넣어주는 date의 채팅도 포함해서 계산하는 것 같음
                                            )
                                            
                                            return .success(ansModel)
                                            
                                        case .failure(let networkError):
                                            return .failure(networkError)
                                            
                                        }
                                    }
                                
                            case .failure(let networkError):
//                                return .failure(networkError)
                                
//                                return Single(.success(.failure(networkError)))

                                return Single.just(.failure(networkError))
//                                return Single.create(.failure(networkError))
                                
                            }
                        }
                    }
                    
                    return Single.zip(singleArr)
                        .map { results -> Result<[DMChattingCellInfoModel], NetworkError> in
                            
                            let dmChattingCellInfoModels = results.compactMap { result -> DMChattingCellInfoModel? in
                                switch result {
                                case .success(let model):
                                    return model
                                case .failure:
                                    return nil
                                }
                            }
                            
                            return .success(dmChattingCellInfoModels)
                        }
                    
                case .failure(let networkError):
                    return Single.just(.failure(networkError))
                 
                }
                
            }
        
        
    }
    
    
    /*
    func fetchDMList(_ workSpaceId: Int) -> Single<Result<[DMChattingCellInfoModel], NetworkError> > {
        
        // 1. (API) DM 방 리스트 조회
        return repo.fetchDMList(workSpaceId)
            .filter { result in
                switch result {
                case .success:
                    return true
                case .failure:
                    return false
                }
            }
            .flatMap { /*(result: Result<[WorkSpaceDMInfoModel], NetworkError>) -> Single<Result<[DMChattingCellInfoModel], NetworkError> > */ result in
                    
                // 성공일 때만 filter로 걸렀기 때문에 success만 진행될 예정
                switch result {
                case .success(let dmInfoArr):
                    
                    // Single 모음집을 만든다.
                    let singleArr: [Single<Result<DMChattingCellInfoModel, NetworkError> >]  = dmInfoArr.map { dmInfo in
                        let requestModel = DMChattingRequestModel(
                            partnerUserId: dmInfo.userId,
                            workSpaceId: workSpaceId,
                            cursorDate: ""
                        )
                        
                        return repo.fetchLastChattingInfo(requestModel: requestModel)
                            .map { response in
                                switch response {
                                case .success(let lastChatInfo):
                                    let newData = DMChattingCellInfoModel(
                                        roomId: lastChatInfo.roomId,
                                        userInfo: lastChatInfo.user,
                                        lastContent: lastChatInfo.content,
                                        lastDate: lastChatInfo.createdAt,
                                        unreadCount: -1
                                    )
                                    return .success(newData)
                                    
                                case .failure(let networkError):
                                    return .failure(networkError)
                                }
                            }
                    }
                    
                    return Single.zip(singleArr)
                        .map { results in
                            let dmChattingCellInfoModels = results.compactMap { result -> DMChattingCellInfoModel?  in
                                switch result {
                                case .success(let model):
                                    return model
                                case .failure:
                                    return nil
                                }
                            }
                            
                            return Single.just(.success(dmChattingCellInfoModels))
                        }

                    
                    
                case .failure(let networkError):
                    return Single.just(.failure(networkError))
//                    return .failure(networkError)
                }
                
               
        
        
    }

    
}
     
     */
}
