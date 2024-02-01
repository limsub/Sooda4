//
//  DMListViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class DMListViewModel: BaseViewModelType {
    
    /* 네트워크 콜 */
    // 1. (내가 속한 워크스페이스 한 개 조회) -> 워크스페이스 정보 조회, 멤버 리스트 조회
    // 1. (내 프로필 정보 조회) -> 프로필 조회
    // 1. (DM 방 조회) -> DM 리스트 조회
    
    // DM 방 별
    // 2. Realm 탐색 -> 읽은 채팅 중 가장 마지막 날짜 조회
    // 3. (DM 채팅 조회) -> 안읽은 채팅 조회
        // 4 - 1. 안읽은 채팅이 없다면, 디비 마지막 채팅을 보여줌
            // -> unreadCnt = 0
        // 4 - 2. 안읽은 채팅이 있다면, 응답 중 마지막 채팅을 보여줌
            // 5. (읽지 않은 DM 채팅 개수) -> unreadCountLabel 업데이트
    
    
    
    // 워크스페이스 정보
    
    
    struct Input {
        
    }
    
    struct Output {
        let workSpaceImage: PublishSubject<String>
        let profileImage: PublishSubject<String>
        let workSpaceMemeberList: PublishSubject<UserInfoModel>
    }
    
    func transform(_ input: Input) -> Output {
        <#code#>
    }
}
