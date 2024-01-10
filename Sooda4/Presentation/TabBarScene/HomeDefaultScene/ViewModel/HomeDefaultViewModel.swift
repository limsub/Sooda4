//
//  HomeDefaultViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import Foundation

class HomeDefaultViewModel {
    
    private let homeDefaultWorkSpaceUseCase: HomeDefaultWorkSpaceUseCaseProtocol
    
    var workSpaceId: Int
    
    init(workSpaceId: Int, homeDefaultWorkSpaceUseCase: HomeDefaultWorkSpaceUseCaseProtocol) {
        self.homeDefaultWorkSpaceUseCase = homeDefaultWorkSpaceUseCase
        self.workSpaceId = workSpaceId
    }
    
    // 처음 필요한 네트워크 콜
    
//    (GET, /v1/workspaces/{id}) 를 통해 워크스페이스 정보
//    (GET, /v1/workspaces/{id}/channels/my) 를 통해 채널 정보
//    (GET, /v1/workspaces/{id}/dms) 을 통해 다이렉트 메시지 정보
//    (GET, /v1/users/my) 을 통해 프로필 정보
    func fetchFirstData() {
        print(#function)
        print("-----", workSpaceId)
        
        
        print(#function, "hi")

        homeDefaultWorkSpaceUseCase.myOneWorkSpaceInfoRequest(workSpaceId) { response  in
            print("1--------------")
                print(response)
            }
        
        homeDefaultWorkSpaceUseCase.workSpaceChannelsRequest(workSpaceId) { response  in
                print("2--------------")
                print(response)
            }
        
        homeDefaultWorkSpaceUseCase.workSpaceDMsRequest(workSpaceId) { response  in
            print("3--------------")
            print(response)
        }
        
        homeDefaultWorkSpaceUseCase.workSpaceMyProfileRequest { response  in
            print("4--------------")
            print(response)
        }
    }
    
    
    
    
    
    // 그 다음
    // (GET, /v1/workspaces/{id}/channels/{name}/unreads) 를 통해 읽지 않은 채널 채팅 개수 확인
    // GET, /v1/workspaces/{id}/dms/{roomID}/unreads) 를 통해 읽지 않은 디엠 채팅 개수 확인
    
    
    
}
