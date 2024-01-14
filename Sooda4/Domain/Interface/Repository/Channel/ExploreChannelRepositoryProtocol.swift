//
//  ExploreChannelRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ExploreChannelRepositoryProtocol {
    // 1. 모든 채널 조회
    func workSpaceAllChannelsRequest(_ requestModel: Int) -> Single< Result< [WorkSpaceChannelInfoModel], NetworkError> >
    
    // 2. 특정 채널의 멤버 조회
    func channelMembersRequest(_ requestModel: ChannelDetailRequestModel) -> Single< Result<[WorkSpaceUserInfo], NetworkError> >
}
