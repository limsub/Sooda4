//
//  MyWorkSpaceRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation

// Rx 사용 x
protocol MyWorkSpaceRepositoryProtocol {
    // (1). 워크스페이스의 채널 정보
    // (2). 워크스페이스의 디엠 정보
    // (3). 내 프로필 정보
    
    
    func workSpaceChannelsRequest(_ requestModel: Int)
}
