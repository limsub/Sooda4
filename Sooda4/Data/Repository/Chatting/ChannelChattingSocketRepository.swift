//
//  ChannelChattingSocketRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/26/24.
//

import Foundation

class ChannelChattingSocketRepository {
    
    let socketManager = SocketIOManager.shared
    
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
}
