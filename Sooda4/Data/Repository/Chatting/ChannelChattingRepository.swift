//
//  ChannelChattingRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ChannelChattingRepository: ChannelChattingRepositoryProtocol {
    
    // 1. 특정 채널 채팅 조회
    func channelChattingsRequest(_ requestModel: ChannelChattingRequestModel) -> Single<Result<[ChannelChattingModel], NetworkError>> {
        
        let dto = ChannelChattingRequestDTO(requestModel)
        
        return NetworkManager.shared.request(
            type: ChannelChattingResponseDTO.self,
            api: .channelChattings(dto)
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
    
    
    /* 2. 디비 */
    private let realm = try! Realm()
    func printURL() {
        print(realm.configuration.fileURL!)
    }
    
    // - 1. 저장된 데이터 중 가장 마지막 날짜 확인. 데이터가  없으면 nil return -> api call 파라미터 빈 문자열
    func checkLastDate(channelId: Int) -> Date? {
        
        return realm.objects(ChattingInfoTable.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .first?
            .createdAt
    }
    // 여기서 받은 Date를 cursor date로 해서 channelChattingRequest 요청
    
    
    // - 2. 네트워크 통신을 통해 받은 데이터들을 realm에 저장
    func addData(dataList: [ChannelChattingDTO]) {
        
        do {
            try realm.write {
                dataList.forEach { dto in
                    let table = ChattingInfoTable(dto)
                    realm.add(table)
                }
            }
        } catch {
            print("에러났슈 - realm")
        }
    }
    
    // - 3 - 1. 특정 날짜 기준 이전으로 30개의 데이터를 가져온다 (디비)
    func fetchPreviousData(channelId: Int, targetDate: Date) -> [ChattingInfoModel] {
        
        return realm.objects(ChattingInfoTable.self)
            .filter("channelId == %@ AND createdAt <= %@", channelId, targetDate)
            .sorted(byKeyPath: "createdAt")
            .prefix(30)
            .map { $0.toDomain() }
    }
    
    
    // - 3 - 2. 특정 날짜 기준 이후로 30개의 데이터를 가져온다 (네트워크)
//    func fetchNextData(channelId: Int, targetDate: Date) -> [ChattingInfoModel] {
//        
//        
//    }
}


