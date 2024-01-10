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
    /* ===== 네트워크 통신을 통해 데이터 저장 ===== */
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
//            print(self.workSpaceInfo)
//            print(self.myProfileInfo)
//            print(self.channelData)
//            print(self.dmData)
            
            
//            self.channelData?.sectionData.forEach({ item in
//                print(" -- channel : ", item.channelInfo.name)
//            })
//            self.dmData?.sectionData.forEach({ item  in
//                print(" -- dm roomID : ", item.dmInfo.roomId)
//                print(" -- dm name : ", item.dmInfo.userNickname)
//            })
            completion()
        }
    }
    
    
    
    // 그 다음
    // (GET, /v1/workspaces/{id}/channels/{name}/unreads) 를 통해 읽지 않은 채널 채팅 개수 확인
    // GET, /v1/workspaces/{id}/dms/{roomID}/unreads) 를 통해 읽지 않은 디엠 채팅 개수 확인
    
    
    
    
    /* ===== tableView DataSource에서 사용하기 위한 데이터 가공 및 로직 ===== */
    func numberOfRowsInSection(section: Int) -> Int {
        guard let channelData, let dmData else { return 0 }
        
        switch section {
        case 0:
            return (channelData.isOpened)
            ? channelData.sectionData.count + 2
            : 1
            
        case 1:
            return (dmData.isOpend)
            ? dmData.sectionData.count + 2
            : 1
            
        case 2:
            return 1
            
        default: return 0
        }
    }
    
    func checkCellType(indexPath: IndexPath) -> HomeDefaultTableViewCellType {
        guard let channelData, let dmData else { return .plusCell }
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0), (1, 0): return .foldingCell
            
        case (0, channelData.sectionData.count + 1), (1, dmData.sectionData.count + 1), (2, 0): return .plusCell
            
        case (0, _): return .channelCell
            
        case (1, _): return .dmCell
            
        default: return .plusCell
            
        }
    }
    
    func foldingCellData(_ indexPath: IndexPath) -> (String, Bool) {
        if indexPath.section == 0 {
            return (channelData?.title ?? "", channelData?.isOpened ?? true)
        } else {
            return (dmData?.title ?? "", dmData?.isOpend ?? true)
        }
    }
    
    func channelCellData(_ indexPath: IndexPath) -> (String, Int) {
        guard let channelData else { return ("", 0) }
        
        return (
            channelData.sectionData[indexPath.row - 1].channelInfo.name,
            channelData.sectionData[indexPath.row - 1].unreadCount
        )
    }
    
    func dmCellData(_ indexPath: IndexPath) -> (String?, String, Int) {
        guard let dmData else { return (nil, "", 0) }
        
        return (
            dmData.sectionData[indexPath.row - 1].dmInfo.userProfilImage,
            dmData.sectionData[indexPath.row - 1].dmInfo.userNickname,
            dmData.sectionData[indexPath.row - 1].unreadCount
        )
    }
    
    func toggleOpenedData(_ indexPath: IndexPath, completion: @escaping () -> Void) {
        
        if indexPath.section == 0 {
            channelData?.isOpened.toggle()
            completion()
            
        } else {
            dmData?.isOpend.toggle()
            completion()
            
        }
        
    }
    
    
    func guardVMData() -> Bool {
        guard let channelData, let dmData else { return false }
        
        return true
    }
    
    
}
