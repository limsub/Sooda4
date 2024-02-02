//
//  DMModel.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import Foundation

struct DMChattingModel {
    let dmId: Int
    let roomId: Int
    let content: String
    let createdAt: Date
    let files: [String]
    let user: UserInfoModel
}


// 1. DM 방 조회
// 요청 : workSpaceId: Int
// 응담 : [WorkSpaceDMInfoModel]


// 2. DM 채팅 생성
struct MakeDMChattingRequestModel {
    let roomId: Int
    let workSpaceId: Int
    let content: String
    let files: [FileDataModel]
}
// 응답 : DMChattingModel


// 3. DM 채팅 조회
struct DMChattingRequestModel {
    let partnerUserId: Int
    let workSpaceId: Int
    let cursorDate: String
}
// 응답 : [DMChattingDTO] (- workSpaceId랑 roomId 제외)


// 4. 읽지 않은 DM 채팅 개수
struct DMUnreadCountRequestModel {
    let dmRoomId: Int
    let workSpaceId: Int
    let after: String
}
struct DMUnreadCountInfoModel {
    let count: Int
}


//
//func fetchDMList(_ workSpaceId: Int) -> Single<Result<[DMChattingCellInfoModel], NetworkError>> {
//    
//    return repo.fetchDMList(workSpaceId)
//        .flatMap { result -> Single<Result<[DMChattingCellInfoModel], NetworkError>> in
//            switch result {
//            case .success(let dmInfoList):
//                
//                let chatInfoRequests = dmInfoList.map { dmInfo in
//                    // 2. (API) 각 방 별로 마지막 채팅 정보 조회 (realm 사용 x)
//                    return repo.fetchLastChattingInfo(requestModel: DMChattingRequestModel(partnerUserId: dmInfo.userId, workSpaceId: workSpaceId, cursorDate: ""))
//                        .flatMap { lastChatInfoResult -> Single<Result<DMChattingCellInfoModel, NetworkError>> in
//                            switch lastChatInfoResult {
//                            case .success(let lastChatInfo):
//                                // 3. (Realm + API) 각 방 별 읽지 않은 채팅 개수 조회
//                                guard let lastChatDate = self.realmManager.fetchLastDMChattingDate(roomId: lastChatInfo.roomId) else {
//                                    // Handle the case where the last chat date is not available in Realm
//                                    return Single.just(.failure(NetworkError.unknown))
//                                }
//                                
//                                let requestModel = DMUnreadCountRequestModel(roomId: lastChatInfo.roomId, lastChatDate: lastChatDate)
//                                
//                                return self.repo.fetchUnreadCountChatting(requestModel)
//                                    .map { unreadCountResult -> Result<DMChattingCellInfoModel, NetworkError> in
//                                        switch unreadCountResult {
//                                        case .success(let unreadCountInfo):
//                                            return .success(DMChattingCellInfoModel(dmInfo: dmInfo, lastChatInfo: lastChatInfo, unreadCount: unreadCountInfo.unreadCount))
//                                        case .failure(let error):
//                                            return .failure(error)
//                                        }
//                                    }
//                            case .failure(let error):
//                                return Single.just(.failure(error))
//                            }
//                        }
//                }
//                
//                return Single.zip(chatInfoRequests)
//                    .map { results -> Result<[DMChattingCellInfoModel], NetworkError> in
//                        let dmChattingCellInfoModels = results.compactMap { result -> DMChattingCellInfoModel? in
//                            switch result {
//                            case .success(let model):
//                                return model
//                            case .failure:
//                                return nil
//                            }
//                        }
//                        return .success(dmChattingCellInfoModels)
//                    }
//                
//            case .failure(let error):
//                return Single.just(.failure(error))
//            }
//        }
//}
