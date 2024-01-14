//
//  InviteWorkSpaceMemberRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class InviteWorkSpaceMemberRepository: InviteWorkSpaceMemberRepositoryProtocol {
    
    // (1). 워크스페이스 멤버 초대
    func inviteMemberRequest(_ requestModel: InviteWorkSpaceMemberRequestModel) -> Single<Result<WorkSpaceUserInfo, NetworkError>> {
        
        // 1. requestDTO
        let dto = InviteWorkSpaceMemberRequestDTO(requestModel)
        
        // 2. request
        return NetworkManager.shared.request(
            type: UserInfoDTO.self,
            api: .inviteWorkSpaceMember(dto)
        )
        .map { result in
            switch result {
            case .success(let dtoData):
                let responseModel = dtoData.toDomain()
                return .success(responseModel)
                
            case .failure(let networkError):
                return .failure(networkError)
            }
        }
    }
}
