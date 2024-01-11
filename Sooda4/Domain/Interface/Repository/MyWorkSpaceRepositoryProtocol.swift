//
//  MyWorkSpaceRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation

// Rx 사용 x
protocol MyWorkSpaceRepositoryProtocol {
    // (0). 워크스페이스 정보 (MyOneWorkSpaceModel)
    // (1). 워크스페이스의 채널 정보 (WorkSpaceChannelInfoModel)
    // (2). 워크스페이스의 디엠 정보 (WorkSpaceDMInfoModel)
    // (3). 내 프로필 정보 (WorkSpaceMyProfileInfoModel)
    
    
    // (0) 호출하면 (1) 정보 얻어낼 수 있지만! 편의를 위해 따로 호출한다
    
    
    func myOneWorkSpaceInfoRequest(_ requestModel: Int, completion: @escaping (Result<MyOneWorkSpaceModel, NetworkError>) -> Void)
    
    
    func workSpaceChannelsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceChannelInfoModel], NetworkError>) -> Void)
    
    func workSpaceDMsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceDMInfoModel], NetworkError>) -> Void )
    
    func workSpaceMyProfileRequest(completion: @escaping (Result<WorkSpaceMyProfileInfoModel, NetworkError>) -> Void )
}
