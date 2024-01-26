//
//  ChannelChattingSocketRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/26/24.
//

import Foundation

class SocketChannelChattingRepository: SocketChannelChattingRepositoryProtocol {
    
    private let socketManager = SocketIOManager.shared
    
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
            }
    }
}


