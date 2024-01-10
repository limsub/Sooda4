//
//  HomeDefaultWorkSpaceRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation

class HomeDefaultWorkSpaceRepository: MyWorkSpaceRepositoryProtocol {
    
    // 워크스페이스 정보
    func myOneWorkSpaceInfoRequest(_ requestModel: Int, completion: @escaping (Result<MyOneWorkSpaceModel, NetworkError>) -> Void) {
        
        
        <#code#>
    }
    
    // 워크스페이스 채널들 정보
    func workSpaceChannelsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceChannelInfoModel], NetworkError>) -> Void) {
        <#code#>
    }
    
    // 워크스페이스 디엠들 정보
    func workSpaceDMsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceDMInfoModel], NetworkError>) -> Void) {
        <#code#>
    }
    
    // 내 프로필 정보
    func workSpaceMyProfileRequest(completion: @escaping (Result<WorkSpaceMyProfileInfoModel, NetworkError>) -> Void) {
        <#code#>
    }
    
    
}
