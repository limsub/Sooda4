//
//  HomeDefaultWorkSpaceUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/10/24.
//

import Foundation

protocol HomeDefaultWorkSpaceUseCaseProtocol {
    /* === 네트워크 === */
    func myOneWorkSpaceInfoRequest(_ requestModel: Int, completion: @escaping (Result<MyOneWorkSpaceModel, NetworkError>) -> Void)
    
    func workSpaceChannelsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceChannelInfoModel], NetworkError>) -> Void)
    
    func workSpaceDMsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceDMInfoModel], NetworkError>) -> Void )
    
    func workSpaceMyProfileRequest(completion: @escaping (Result<WorkSpaceMyProfileInfoModel, NetworkError>) -> Void )
}

class HomeDefaultWorkSpaceUseCase: HomeDefaultWorkSpaceUseCaseProtocol {
    
    // 1. repo
    let myWorkSpaceInfoRepository: MyWorkSpaceRepositoryProtocol
    
    // 2. init (의존성 주입)
    init(myWorkSpaceInfoRepository: MyWorkSpaceRepositoryProtocol) {
        self.myWorkSpaceInfoRepository = myWorkSpaceInfoRepository
    }
    
    
    // 3. 프로토콜 메서드 (네트워크)
    func myOneWorkSpaceInfoRequest(_ requestModel: Int, completion: @escaping (Result<MyOneWorkSpaceModel, NetworkError>) -> Void) {
        
        myWorkSpaceInfoRepository.myOneWorkSpaceInfoRequest(requestModel, completion: completion)
    }
    
    func workSpaceChannelsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceChannelInfoModel], NetworkError>) -> Void) {
        
        myWorkSpaceInfoRepository.workSpaceChannelsRequest(requestModel, completion: completion)
    }
    
    func workSpaceDMsRequest(_ requestModel: Int, completion: @escaping (Result<[WorkSpaceDMInfoModel], NetworkError>) -> Void) {
        
        myWorkSpaceInfoRepository.workSpaceDMsRequest(requestModel, completion: completion)
    }
    
    func workSpaceMyProfileRequest(completion: @escaping (Result<WorkSpaceMyProfileInfoModel, NetworkError>) -> Void) {
        
        myWorkSpaceInfoRepository.workSpaceMyProfileRequest(completion: completion)
    }
}
