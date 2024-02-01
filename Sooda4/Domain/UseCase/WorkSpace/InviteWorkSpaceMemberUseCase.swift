//
//  InviteWorkSpaceMemberUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol InviteWorkSpaceMemberUseCaseProtocol {
    /* === 네트워크 === */
    // 이메일 초대
    func inviteMemberRequest(_ requestModel: InviteWorkSpaceMemberRequestModel) -> Single< Result<UserInfoModel, NetworkError> >
    
    
    /* === 로직 === */
    func checkEmailFormat(_ txt: String) -> Bool
}

class InviteWorkSpaceMemberUseCase: InviteWorkSpaceMemberUseCaseProtocol {
    
    // 1. repo
    private let inviteWorkSpaceMemberRepository: InviteWorkSpaceMemberRepositoryProtocol
    
    // 2. init
    init(inviteWorkSpaceMemberRepository: InviteWorkSpaceMemberRepositoryProtocol) {
        self.inviteWorkSpaceMemberRepository = inviteWorkSpaceMemberRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func inviteMemberRequest(_ requestModel: InviteWorkSpaceMemberRequestModel) -> Single<Result<UserInfoModel, NetworkError>> {
        
        return inviteWorkSpaceMemberRepository.inviteMemberRequest(requestModel)
    }
    
    // 4. 프로토콜 메서드 (로직)
    func checkEmailFormat(_ txt: String) -> Bool {
        if txt.contains("@") && txt.contains(".com") { return true }
        else { return false }
    }
}
