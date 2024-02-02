//
//  SocketChannelChattingRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/26/24.
//

import Foundation


protocol SocketChannelChattingRepositoryProtocol {
    
    // 연결
    func openSocket(_ channelId: Int)
    
    // 해제
    func closeSocket()
    
    // 응답
    func receiveSocket(_ channelId: Int, completion: @escaping (ChannelChattingInfoModel)-> Void)
}

