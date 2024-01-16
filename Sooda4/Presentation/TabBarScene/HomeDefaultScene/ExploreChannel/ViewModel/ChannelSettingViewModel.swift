//
//  ChannelSettingViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation


class ChannelSettingViewModel {
    
    // 초기 데이터
    let workSpaceId: Int
    let channelName: String
    let channelSettingUseCase: ChannelSettingUseCaseProtocol
    
    init(workSpaceId: Int, channelName: String, channelSettingUseCase: ChannelSettingUseCaseProtocol) {
        self.workSpaceId = workSpaceId
        self.channelName = channelName
        self.channelSettingUseCase = channelSettingUseCase
    }
    
    // 뷰에 띄울 데이터
    var channelInfoData: OneChannelInfoModel?
    
    // 버튼 구조체
    struct ButtonInfo {
        let title: String
        let isRed: Bool
    }
    var handleButtonInfo = [
        ButtonInfo(title: "채널 편집", isRed: false),
        ButtonInfo(title: "채널에서 나가기", isRed: false),
        ButtonInfo(title: "채널 관리자 변경", isRed: false),
        ButtonInfo(title: "채널 삭제", isRed: true )
    ]
    
    // 멤버뷰 오픈 여부
    var isMemberViewOpened = true
    
    // 관리자 여부
    var isAdmin = false
    
    
    // 데이터 호출
    func fetchData(completion: @escaping () -> Void) {
        
        let requestModel = ChannelDetailRequestModel(workSpaceId: workSpaceId, channelName: channelName)
        
        channelSettingUseCase.oneChannelInfoRequest(requestModel) { response  in
            switch response {
            case .success(let model):
                self.channelInfoData = model
                // * 임시
                if model.ownerId == KeychainStorage.shared._id ?? -1 {
                    self.isAdmin = true
                } else {
                    self.isAdmin = false
                }
                
                completion()
                
            case .failure(let networkError):
                print("에러났슈 : \(networkError)")
            }
        }
    }
    
    
}

// 테이블뷰 관련 로직
extension ChannelSettingViewModel {
    // 섹션 종류
    enum SectionType {
        case info, memberFolding, members, button
    }
    func sectionType(indexPath: IndexPath) -> SectionType {
        switch (indexPath.section, indexPath.row) {
        case (0, 0): return .info
        case (1, 0): return .memberFolding
        case (1, 1): return .members
        case (2, _): return .button
        default: return .info
        }
        
    }
    
    // row 개수
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return isMemberViewOpened ? 2 : 1
        case 2: return isAdmin ? 4 : 1
        default: return 0
        }
    }
    
    // info 셀에 들어가는 데이터
    func channelInfoForInfoCell() -> (String, String?) {
        guard let channelInfoData else { return ("-1", "-1")}
        
        return (channelInfoData.channelName, channelInfoData.channelDescription)
    }
    
    // member Folding 셀에 들어가는 데이터
    func memberCountForFoldingCell() -> Int {
        guard let channelInfoData else { return -1}
        
        return channelInfoData.users.count
    }
    
    // memebers 셀에 들어가는 데이터
    func memberInfoForMembersCell() -> [WorkSpaceUserInfo] {
        guard let channelInfoData else { return [] }
        
        return channelInfoData.users
    }
    
    // 버튼 셀에 들어가는 데이터
    func buttonDataForButtonCell(indexPath: IndexPath) -> (String, Bool) {
        // isAdmin
        
        if !isAdmin {
            return ("채널에서 나가기", false)
        }
            
        let data = handleButtonInfo[indexPath.row]
        return (data.title, data.isRed)
    }
    
    
    
    // member folding 셀 클릭 시
    func toggleOpenValue(indexPath: IndexPath, completion: @escaping () -> Void) {
        if (indexPath.section, indexPath.row) == (1, 0) {
            isMemberViewOpened.toggle()
            completion()
        }
    }
}
