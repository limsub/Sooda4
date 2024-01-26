//
//  SocketRouter.swift
//  Sooda4
//
//  Created by 임승섭 on 1/26/24.
//

import Foundation

enum SocketRouter {
    case channel(channelId: Int)
    
    
    var event: String {
        switch self {
        case .channel:
            return "channel"
        }
    }
    
    var nameSpace: String {
        switch self {
        case .channel(let channelId):
            return "/ws-channel-\(channelId)"
        }
    }
}
