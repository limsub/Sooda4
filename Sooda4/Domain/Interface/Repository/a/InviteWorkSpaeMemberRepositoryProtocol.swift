//
//  InviteWorkSpaeMemberRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol InviteWorkSpaceMemberRepositoryProtocol {
    // 1. 워크스페이스 멤버 초대
        // - 요청 타입 String (이메일)
        // - 응답 타입 (UserInfoModel / UserInfoDTO)
    func inviteMemberRequest(_ requestModel: InviteWorkSpaceMemberRequestModel) -> Single< Result< UserInfoModel, NetworkError> >
}
