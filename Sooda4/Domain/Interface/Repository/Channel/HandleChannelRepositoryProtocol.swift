//
//  HandleChannelRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/17/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol HandleChannelRepositoryProtocol {
    
    // 1. 채널 편집
        // (DTO)
        // - 요청 : EditChannelRequestDTO
        // - 응답 : EditChannelResponseDTO
    
        // (MODEL)
        // - 요청 : EditChannelRequestModel
        // - 응답 : WorkSpaceChannelInfoModel
    
    
    // 2. 채널 나가기
        // (DTO)
        // - 요청 : ChannelDetailRequestDTO
        // - 응답 : LeaveChannelResponseDTO
    
        // (MODEL)
        // - 요청 : ChannelDetailRequestModel
        // - 응답 : [WorkSpaceChannelInfoModel]

    
    // 3 - 1. 채널 멤버 조회
        // (DTO)
        // - 요청 : ChannelDetailRequestDTO
        // - 응답 : ChannelMembersResponseDTO
    
        // (MODEL)
        // - 요청 : ChannelDetailRequestModel
        // - 응답 : [WorkSpaceUserInfo]
    
    
    // 3 - 2. 채널 관리자 권한 변경
        // (DTO)
        // - 요청 : ChangeAdminChannelRequestDTO
        // - 응답 : ChangeAdminChannelResponseDTO
    
        // (MODEL)
        // - 요청 : ChangeAdminChannelRequestModel
        // - 응답 : WorkSpaceChannelInfoModel

    
    // 4. 채널 삭제
        // (DTO)
        // - 요청 : ChannelDetailRequestDTO
        // - 응답 : No Response
    
        // (MODEL)
        // - 요청 : ChannelDetailRequestModel
        // - 응답 : No response

    
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
