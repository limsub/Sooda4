//
//  PushNotificationDTO.swift
//  Sooda4
//
//  Created by 임승섭 on 2/6/24.
//

import Foundation

struct PushChannelChattingDTO: Decodable {
    let type: String
    let workspace_id: String
    let channel_id: String
    
    let aps: Aps
    
    let googleCAE: String
    let googleCSenderID: String
    let googleCFid: String
    
    let gcmMessageID: String
    
    private enum CodingKeys: String, CodingKey {
        case type, workspace_id, channel_id, aps
        
        case googleCAE = "google.c.a.e"
        case googleCSenderID = "google.c.sender.id"
        case googleCFid = "google.c.fid"
        
        case gcmMessageID = "gcm.message_id"
    }
}

struct PushDMChattingDTO: Decodable {
    let type: String
    let workspace_id: String
    let opponent_id: String
    
    let aps: Aps
    
    let googleCAE: String
    let googleCSenderID: String
    let googleCFid: String
    
    let gcmMessageID: String
    
    private enum CodingKeys: String, CodingKey {
        case type, workspace_id, opponent_id, aps
        
        case googleCAE = "google.c.a.e"
        case googleCSenderID = "google.c.sender.id"
        case googleCFid = "google.c.fid"
        
        case gcmMessageID = "gcm.message_id"
    }
}


struct Aps: Decodable {
    let alert: Alert
}

struct Alert: Decodable {
    let body: String
    let title: String
}
