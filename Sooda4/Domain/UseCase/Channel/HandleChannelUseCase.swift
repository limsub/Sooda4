//
//  HandleChannelUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/17/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol HandleChannelUseCaseProtocol {
    /* === 네트워크 === */
    // 1. 채널 편집
    func editChannelRequest(_ requestModel: EditChannelRequestModel) -> Single< Result<WorkSpaceChannelInfoModel, NetworkError> >
    // 2. 채널 나가기
    func leaveChannelRequest(_ requestModel: ChannelDetailRequestModel) -> Single< Result<[WorkSpaceChannelInfoModel], NetworkError> >
    
    // 3 - 1. 채널 멤버 조회
    func channelMembersRequest(_ requestModel: ChannelDetailRequestModel, completion: @escaping (Result<[WorkSpaceUserInfo], NetworkError>) -> Void)
    
    // 3 - 2. 채널 관리자 권한 변경
    func chanegAdminChannelRequest(_ requestModel: ChangeAdminChannelRequestModel, completion: @escaping (Result<WorkSpaceChannelInfoModel, NetworkError>) -> Void)
    
    // 4. 채널 삭제
    func deleteChannelRequest(_ requestModel: ChannelDetailRequestModel) -> Single< Result<String, NetworkError> >
}


class HandleChannelUseCase: HandleChannelUseCaseProtocol {

    
    
    // 1. repo
    let handleChannelRepository: HandleChannelRepositoryProtocol
    
    // 2. init
    init(handleChannelRepository: HandleChannelRepositoryProtocol) {
        self.handleChannelRepository = handleChannelRepository
    }
    
    // 1. 채널 편집
    func editChannelRequest(_ requestModel: EditChannelRequestModel) -> RxSwift.Single<Result<WorkSpaceChannelInfoModel, NetworkError>> {
        
        return handleChannelRepository.editChannelRequest(requestModel)
    }
    
    // 2. 채널 나가기
    func leaveChannelRequest(_ requestModel: ChannelDetailRequestModel) -> RxSwift.Single<Result<[WorkSpaceChannelInfoModel], NetworkError>> {
        
        return handleChannelRepository.leaveChannelRequest(requestModel)
    }
    
    // 3 - 1. 채널 멤버 조회
    func channelMembersRequest(_ requestModel: ChannelDetailRequestModel, completion: @escaping (Result<[WorkSpaceUserInfo], NetworkError>) -> Void) {
        
        
    }
    
    
    // 3 - 2. 채널 관리자 권한 변경
    func chanegAdminChannelRequest(_ requestModel: ChangeAdminChannelRequestModel, completion: @escaping (Result<WorkSpaceChannelInfoModel, NetworkError>) -> Void) {
        
    }
    
    
    // 4. 채널 삭제
    func deleteChannelRequest(_ requestModel: ChannelDetailRequestModel) -> RxSwift.Single<Result<String, NetworkError>> {
        
        return handleChannelRepository.deleteChannelRequest(requestModel)
    }
}
