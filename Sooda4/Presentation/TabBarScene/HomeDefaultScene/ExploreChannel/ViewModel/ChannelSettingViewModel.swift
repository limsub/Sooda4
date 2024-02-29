//
//  ChannelSettingViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import Foundation
import RxSwift
import RxCocoa


class ChannelSettingViewModel {
    
    var didSendEventClosure: ( (ChannelSettingViewModel.Event) -> Void )?
    
    var handleChannelUseCase: HandleChannelUseCaseProtocol
    
    private var disposeBag = DisposeBag()
    
    // 초기 데이터
    let workSpaceId: Int
    var channelName: String
    let channelSettingUseCase: ChannelSettingUseCaseProtocol
    
    init(workSpaceId: Int, channelName: String, channelSettingUseCase: ChannelSettingUseCaseProtocol, handleChannelUseCase: HandleChannelUseCaseProtocol) {
        self.workSpaceId = workSpaceId
        self.channelName = channelName
        self.channelSettingUseCase = channelSettingUseCase
        self.handleChannelUseCase = handleChannelUseCase
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
                /* 임시 */
//                self.channelInfoData = model
                
                
                self.channelInfoData = OneChannelInfoModel(
                    channelName: "🎁 정보공유",
                    channelDescription: "'정보 공유' 채널은 여러 분야의 유용한 정보를 효과적으로 공유하고 지식을 확장하기 위한 공간으로서, 최신 뉴스, 도움이 되는 팁, 그리고 흥미로운 자료들을 신속하게 전달하며 회원 간의 지식 교류와 협력을 촉진합니다. 또한, 이 채널은 학습과 성장을 공유하는 다양한 활동을 통해 회원들이 함께 발전할 수 있는 소통의 장을 제공합니다.",
                    ownerId: 0,
                    users: sampleNameArr.map {
                        UserInfoModel(
                            userId: 0,
                            email: "",
                            nickname: $0,
                            profileImage: ""
                        )
                    }
                )
                
                print("channelInfoData 업데이트!")
                print(model)

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
    func memberInfoForMembersCell() -> [UserInfoModel] {
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

// Event
extension ChannelSettingViewModel {
    enum Event {
        case presentEditChannel(workSpaceId: Int, channelName: String)
        case presentChangeAdminChannel(workSpaceId: Int, channelName: String)
        
        case goBackHomeDefault(workSpaceId: Int)
    }
}

// Input / Output
extension ChannelSettingViewModel: BaseViewModelType {
    
    struct Input {
        let buttonClicked: PublishSubject<IndexPath>
        
        let leaveChannel: PublishSubject<Void>  // 채널 나감 (팝업에서 ok 클릭)
        let deleteChanel: PublishSubject<Void>
    }
    
    struct Output {
        let showPopupLeaveChannel: PublishSubject<Bool> // 채널 나가기 팝업 띄우기 -> true일 때 관리자, false일 때 일반
        
        let showPopupDeleteChannel: PublishSubject<Void> // 반드시 관리자
    }
    
    func transform(_ input: Input) -> Output {
        
        let showPopupLeaveChannel = PublishSubject<Bool>()
        let showPopupDeleteChannel = PublishSubject<Void>()
        
        
        // 버튼 클릭
        input.buttonClicked
            .subscribe(with: self) { owner , indexPath in
                
                // 관리자
                if owner.isAdmin {
                    switch indexPath.row {
                    case 0: // 채널 편집
                        print("(관리자) 채널 편집 채널 편집")
                        owner.didSendEventClosure?(.presentEditChannel(
                            workSpaceId: owner.workSpaceId,
                            channelName: owner.channelName
                        ))
                        
                    case 1: // 채널 나가기
                        print("(관리자) 채널 나가 채널 나가")
                        showPopupLeaveChannel.onNext(true)
                        
                    case 2: // 채널 관리자 변경
                        print("(관리자) 채널 관리자 변경 채널 관리자 변경")
                        owner.didSendEventClosure?(.presentChangeAdminChannel(
                            workSpaceId: owner.workSpaceId,
                            channelName: owner.channelName
                        ))
                        
                    case 3: // 채널 삭제
                        print("(관리자) 채널 삭제 채널 삭제")
                        showPopupDeleteChannel.onNext(())
                        
                    default: break
                    }
                }
                
                // 일반
                else {
                    switch indexPath.row {
                    case 0: // 채널 나가기
                        print("(일반) 채널 나가 채널 나가")
                        showPopupLeaveChannel.onNext(false)
                    
                    default: break
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        
        let requestModel = ChannelDetailRequestModel(
            workSpaceId: self.workSpaceId,
            channelName: self.channelName
        )
        
        
        // 채널 나가기 -> 네트워크 콜 200 -> HomeDefault (reload)
        input.leaveChannel
            .flatMap {
                self.handleChannelUseCase.leaveChannelRequest(requestModel)
            }
            .subscribe(with: self) { owner , response in
                print(response)
                print("나가")
                owner.didSendEventClosure?(.goBackHomeDefault(workSpaceId: owner.workSpaceId))
            }
            .disposed(by: disposeBag)
        
        
        // 채널 삭제 -> 네트워크 콜 200 -> HomeDefault (reload)
        input.deleteChanel
            .flatMap {
                self.handleChannelUseCase.deleteChannelRequest(requestModel)
            }
            .subscribe(with: self) { owner , response in
                print(response)
                print("삭제")
                owner.didSendEventClosure?(.goBackHomeDefault(workSpaceId: owner.workSpaceId))
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            showPopupLeaveChannel: showPopupLeaveChannel,
            showPopupDeleteChannel: showPopupDeleteChannel
        )
    }
    
    
}
