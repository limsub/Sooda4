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
    
    
    
    private let realm = try! Realm()
    func printURL() {
        print(realm.configuration.fileURL!)
    }
    
    // - 1. 저장된 데이터 중 가장 마지막 날짜 확인. 데이터가  없으면 nil return -> api call 파라미터 빈 문자열
    func checkLastDate(requestModel: ChannelDetailFullRequestModel) -> Date? {

        return realm.objects(ChattingInfoTable.self)
            .filter(
                "workSpaceId == %@ AND channelId == %@",
                requestModel.workSpaceId,
                requestModel.channelId
            )
            .sorted(byKeyPath: "createdAt", ascending: false)
            .first?
            .createdAt
    }
    // 여기서 받은 Date를 cursor date로 해서 channelChattingRequest 요청
    
    
    
    // - 2. 네트워크 통신을 통해 특정 날짜 이후 최신까지 데이터 불러오기
    //       + 불러온 데이터를 디비에 넣어주기
    //     - 네트워크 통신 완료 시점 때문에 completion 사용
    func fetchRecentChatting(
        channelChattingRequestModel: ChannelChattingRequestModel,
        completion: @escaping () -> Void
    ) {
        
        let dto = ChannelChattingRequestDTO(channelChattingRequestModel)
        
        NetworkManager.shared.requestCompletion(
            type: ChannelChattingResponseDTO.self,
            api: .channelChattings(dto)) { result in
                switch result {
                case .success(let dtoData):
                    print("최신 채팅에 대한 응답 완료. 디비에 넣어주기")
                    print("예외처리 필요 (아직 안함) 소켓이 이미 열렸기 때문에, 소켓에서 받은 채팅이 디비에 있을 수 있다. 즉, 여기서 받은 데이터가 디비에 없는지 확인하는 작업이 필요하다")
                    DispatchQueue.main.async {
                        self.addDataList(
                            dataList: dtoData,
                            workSpaceId: channelChattingRequestModel.workSpaceId
                        )
                        
                        // 이 아래 코드는 굳이 필요한가 싶음. 성공 여부만 알려줘도 충분한데
                        let responseModel = dtoData.map { $0.toDomain() }
                        completion()
                    }
                    
                case .failure(let networkError):
                    print(" *** 에러발생 ***")
                }
            }
    }
    

    
    
    // - 3 - 1. targetDate (포함 o) 이전 데이터 (최대) 30개
    func fetchPreviousData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChattingInfoModel] {
        
        // lastChattingDate가 nil이다
        // -> (createdAt <= %@)디비에 저장된 읽은 데이터가 없다
        guard let targetDate else { return [] }
        
        
        return realm.objects(ChattingInfoTable.self)
            .filter(
                "workSpaceId == %@ AND channelId == %@ AND createdAt <= %@",
                requestModel.workSpaceId,
                requestModel.channelId,
                targetDate
            )
            .sorted(byKeyPath: "createdAt")
            .suffix(30)
            .map { $0.toDomain() }
    }
    
    
    
    // - 3 - 2. targetDate (포함 x) 이후 데이터 (최대) 30개
    func fetchNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChattingInfoModel] {
        
        // lastChattingDate가 nil이다 
        // -> (createdAt > %@) 디비에 저장된 모든 데이터가 읽지 않은 데이터이다
        if let targetDate {
            return realm.objects(ChattingInfoTable.self)
                .filter(
                    "workSpaceId == %@ AND channelId == %@ AND createdAt > %@",
                    requestModel.workSpaceId,
                    requestModel.channelId,
                    targetDate
                )
                .sorted(byKeyPath: "createdAt")
                .prefix(30)
                .map { $0.toDomain() }
            
        } else {
            return realm.objects(ChattingInfoTable.self)
                .filter(
                    "workSpaceId == %@ AND channelId == %@",
                    requestModel.workSpaceId,
                    requestModel.channelId
                )
                .sorted(byKeyPath: "createdAt")
                .prefix(30)
                .map { $0.toDomain() }
            
        }
    }
    
    
    
    // 4. 채팅 전송
    func makeChatting(_ requestModel: MakeChannelChattingRequestModel) -> Single< Result<ChattingInfoModel, NetworkError> > {
        
        let dto = MakeChannelChattingRequestDTO(requestModel)
        
        return NetworkManager.shared.requestMultiPart(
            type: MakeChannelChattingResponseDTO.self,
            api: .makeChannelChatting(dto)
        )
        .map { result in
            switch result {
            case .success(let dtoData):
                print("REPO : 채팅 전송 성공. 성공했으니까 해당 채팅 바로 디비에 저장")
                DispatchQueue.main.async {
                    self.addDataElement(
                        data: dtoData,
                        workSpaceId: requestModel.workSpaceId
                    )
                }
                
                
                let responseModel = dtoData.toDomain()
                return .success(responseModel)
                
            case .failure(let networkError):
                return .failure(networkError)
                
            }
        }
        
    }
}


extension ChannelChattingRepository {
    
    // 채팅 하나를 디비에 저장 (채팅 전송 후 실행)
    private func addDataElement(data: ChannelChattingDTO, workSpaceId: Int) {
        
        do {
            try realm.write {
                print("디비에 채팅 데이터 하나 넣어주기")
                let table = ChattingInfoTable(
                    data,
                    workSpaceId: workSpaceId
                )
                realm.add(table)
            }
        } catch {
            print("에러났슈 - realm")
        }
        
    }
    
    // 채팅 배열을 디비에 저장 (네트워크 응답 받은 후 실행)
    private func addDataList(dataList: [ChannelChattingDTO], workSpaceId: Int) {
        
        do {
            try realm.write {
                print("디비에 채팅 데이터 배열 넣어주기")
                dataList.forEach { dto in
                    let table = ChattingInfoTable(
                        dto,
                        workSpaceId: workSpaceId
                    )
                    realm.add(table)
                }
            }
        } catch {
            print("에러났슈 - realm")
        }
    }
}
