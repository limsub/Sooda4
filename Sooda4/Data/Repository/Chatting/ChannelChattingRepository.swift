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
    
    private let realmManager = RealmManager()
    // 생성 시점에 키체인에 저장된 user id에 따라 realm 파일이 달라짐
    
    
    // - 1. 저장된 데이터 중 가장 마지막 날짜 확인. 데이터가  없으면 nil return -> api call 파라미터 빈 문자열
    func checkLastDate(requestModel: ChannelDetailFullRequestModel) -> Date? {
        
        return realmManager.checkChannelChattingLastDate(
            requestModel: requestModel
        )
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
                    print("최신 채팅에 대한 응답 완료 - v1 : 확인한 채팅 중 마지막 채팅도 포함해서 받음. 디비에 넣어주기")
                    dtoData.forEach { item in
                        print(item)
                    }
                    
                    
                    print("예외처리 필요 (완료) 소켓이 이미 열렸기 때문에, 소켓에서 받은 채팅이 디비에 있을 수 있다. 즉, 여기서 받은 데이터가 디비에 없는지 확인하는 작업이 필요하다")
                    DispatchQueue.main.async {
                        self.addDataList(
                            dataList: dtoData,
                            workSpaceId: channelChattingRequestModel.workSpaceId
                        )
                        
                        // 이 아래 코드는 굳이 필요한가 싶음. 성공 여부만 알려줘도 충분한데
//                        let responseModel = dtoData.map { $0.toDomain() }
                        completion()
                    }
                    
                case .failure(let networkError):
                    print(" *** 에러발생 ***")
                }
            }
    }
    

    
    
    // - 3 - 1. targetDate (포함 o) 이전 데이터 (최대) 30개
    // 맨 처음만 targetDate 포함해서 주고, 그 이후에는 포함하지 않아야 한다
    func fetchPreviousData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?, isFirst: Bool) -> [ChattingInfoModel] {
        
        return realmManager.fetchPreviousData(
            requestModel: requestModel,
            targetDate: targetDate,
            isFirst: isFirst
        )
    }
    
    
    
    // - 3 - 2. targetDate (포함 x) 이후 데이터 (최대) 30개
    func fetchNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChattingInfoModel] {
        
        return realmManager.fetchNextData(
            requestModel: requestModel,
            targetDate: targetDate
        )
    }
    
    
    // - 3 - 3. targetDate (포함 x) 이후 데이터 모두 가져오기
    func fetchAllNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChattingInfoModel] {
        
        return realmManager.fetchAllNextData(
            requestModel: requestModel,
            targetDate: targetDate
        )
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
    
    // ChannelChattinDTO 타입으로 채팅 정보를 받을 때, 이 채팅 정보를 디비에 저장하기
    private func addDTOData(dtoData: ChannelChattingDTO, workSpaceId: Int) {
        
        realmManager.addChannelChattingData(
            dtoData: dtoData,
            workSpaceId: workSpaceId
        )
    }
    
    // 채팅 하나를 디비에 저장 (채팅 전송 후 실행)
    private func addDataElement(data: ChannelChattingDTO, workSpaceId: Int) {
        
        self.addDTOData(
            dtoData: data,
            workSpaceId: workSpaceId
        )
    }
    
    // 채팅 배열을 디비에 저장 (네트워크 응답 받은 후 실행)
    private func addDataList(dataList: [ChannelChattingDTO], workSpaceId: Int) {
        
        dataList.forEach { data in
            self.addDTOData(
                dtoData: data,
                workSpaceId: workSpaceId
            )
        }
    }
}
