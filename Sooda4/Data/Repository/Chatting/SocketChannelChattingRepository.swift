//
//  ChannelChattingSocketRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/26/24.
//

import Foundation
import RealmSwift

class SocketChannelChattingRepository: SocketChannelChattingRepositoryProtocol {
    
//    private let realm = try! Realm()
    private let socketManager = SocketIOManager.shared
    private let realmManager = RealmManager()
    // 생성 시점에 키체인에 저장된 user id에 따라 realm 파일이 달라짐
    
    // 연결
    func openSocket(_ channelId: Int) {
        socketManager.establishConnection(
            .channel(channelId: channelId)
        )
    }
    
    // 해제
    func closeSocket() {
        socketManager.closeConnection()
    }
    
    // 응답
    func receiveSocket(_ channelId: Int, completion: @escaping (ChattingInfoModel)-> Void) {
        
        socketManager.receive(
            type: SocketchannelChattingResponseDTO.self,
            router: .channel(channelId: channelId)) { dtoData in
                let responseModel = dtoData.toDomain()
                completion(responseModel)
                
                DispatchQueue.main.async {
                    if dtoData.user.user_id != KeychainStorage.shared._id {
                        self.addDataElement(
                            data: dtoData,
                            workSpaceId: -1 // 아 이거 언제 또 받아오냐
                        )
                    }
                }
            }
    }
}


extension SocketChannelChattingRepository {
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
    
}
