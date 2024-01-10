//
//  HomeDefaultViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import Foundation


struct HomeDefaultChannelsDataModel {
    let title = "채널"
    var isOpened: Bool
    var sectionData: [ChannelCellInfo]
    
    struct ChannelCellInfo {
        let channelInfo: WorkSpaceChannelInfoModel
        let unreadCount: Int
    }
}

struct HomeDefaultDMsDataModel {
    let title = "다이렉트 메시지"
    var isOpend: Bool
    var sectionData: [DMCellInfo]
    
    struct DMCellInfo {
        let dmInfo: WorkSpaceDMInfoModel
        let unreadCount: Int
    }
}


class HomeDefaultViewModel {
    
    private let homeDefaultWorkSpaceUseCase: HomeDefaultWorkSpaceUseCaseProtocol
    
    var workSpaceId: Int
    
    init(workSpaceId: Int, homeDefaultWorkSpaceUseCase: HomeDefaultWorkSpaceUseCaseProtocol) {
        self.homeDefaultWorkSpaceUseCase = homeDefaultWorkSpaceUseCase
        self.workSpaceId = workSpaceId
    }
    
    // 뷰를 그려주기 위한 데이터
    var workSpaceInfo: MyOneWorkSpaceModel? // 네비게이션 - 이미지, 타이틀
    var myProfileInfo: WorkSpaceMyProfileInfoModel?  // 네비게이션 - 이미지
    var channelData: HomeDefaultChannelsDataModel?
    var dmData: HomeDefaultDMsDataModel?
    
    
    
    // 처음 필요한 네트워크 콜
    
//    (GET, /v1/workspaces/{id}) 를 통해 워크스페이스 정보
//    (GET, /v1/workspaces/{id}/channels/my) 를 통해 채널 정보
//    (GET, /v1/workspaces/{id}/dms) 을 통해 다이렉트 메시지 정보
//    (GET, /v1/users/my) 을 통해 프로필 정보
    func fetchFirstData(completion: @escaping () -> Void) {
        
        let group = DispatchGroup()
        
        group.enter()
        homeDefaultWorkSpaceUseCase.myOneWorkSpaceInfoRequest(workSpaceId) { [weak self] response  in
            
            switch response {
            case .success(let data):
                self?.workSpaceInfo = data
                
            case .failure(let networkError):
                print("아직 에러 처리 안했으 에러 : \(networkError)")
            }
            
            group.leave()
        }
        
        group.enter()
        homeDefaultWorkSpaceUseCase.workSpaceChannelsRequest(workSpaceId) { response  in
            switch response {
            case .success(let data):
                self.channelData = HomeDefaultChannelsDataModel(
                    isOpened: true,
                    sectionData: data.map {
                        HomeDefaultChannelsDataModel.ChannelCellInfo(
                            channelInfo: $0,
                            unreadCount: 10
                        )
                    }
                )
            case .failure(let networkError):
                print("아직 에러 처리 안했으 에러 : \(networkError)")
            }
            
            group.leave()
        }
        
        group.enter()
        homeDefaultWorkSpaceUseCase.workSpaceDMsRequest(workSpaceId) { response  in
            
            switch response {
            case .success(let data):
                self.dmData = HomeDefaultDMsDataModel(
                    isOpend: true ,
                    sectionData: data.map {
                        HomeDefaultDMsDataModel.DMCellInfo(
                            dmInfo: $0,
                            unreadCount: 10
                        )
                    }
                )
            case .failure(let networkError):
                print("아직 에러 처리 안했으 에러 : \(networkError)")
            }
            
            group.leave()
        }
        
        group.enter()
        homeDefaultWorkSpaceUseCase.workSpaceMyProfileRequest { response  in
            
            switch response {
            case .success(let data):
                self.myProfileInfo = data
            case .failure(let networkError):
                print("아직 에러 처리 안했으 에러 : \(networkError)")
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("END")
            print("workSpaceId: \(self.workSpaceId)")
            print(self.workSpaceInfo)
            print(self.myProfileInfo)
//            print(self.channelData)
//            print(self.dmData)
            
            
            self.channelData?.sectionData.forEach({ item in
                print(" -- channel : ", item.channelInfo.name)
            })
            self.dmData?.sectionData.forEach({ item  in
                print(" -- dm roomID : ", item.dmInfo.roomId)
                print(" -- dm name : ", item.dmInfo.userNickname)
            })
            
        }
    }
    
    
    
    
    
    // 그 다음
    // (GET, /v1/workspaces/{id}/channels/{name}/unreads) 를 통해 읽지 않은 채널 채팅 개수 확인
    // GET, /v1/workspaces/{id}/dms/{roomID}/unreads) 를 통해 읽지 않은 디엠 채팅 개수 확인
    
    
    
}
