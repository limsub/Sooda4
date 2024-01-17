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
    func channelMembersRequest(_ requestModel: ChannelDetailRequestModel) -> Single< Result<[WorkSpaceUserInfo], NetworkError> >
    // 3 - 2. 채널 관리자 권한 변경
    func changeAdminChannelRequest(_ requestModel: ChangeAdminChannelRequestModel) -> Single< Result<WorkSpaceChannelInfoModel, NetworkError> >
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
    func channelMembersRequest(_ requestModel: ChannelDetailRequestModel) -> RxSwift.Single<Result<[WorkSpaceUserInfo], NetworkError>> {
        
        return handleChannelRepository.channelMembersRequest(requestModel)
    }
    
    // 3 - 2. 채널 관리자 권한 변경
    func changeAdminChannelRequest(_ requestModel: ChangeAdminChannelRequestModel) -> RxSwift.Single<Result<WorkSpaceChannelInfoModel, NetworkError>> {
        
        return handleChannelRepository.changeAdminChannelRequest(requestModel)
    }
    
    // 4. 채널 삭제
    func deleteChannelRequest(_ requestModel: ChannelDetailRequestModel) -> RxSwift.Single<Result<String, NetworkError>> {
        
        return handleChannelRepository.deleteChannelRequest(requestModel)
    }
}
