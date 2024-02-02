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
    
    let workSpaceId: Int
    
    private var disposeBag = DisposeBag()
    
    let dmListUseCase = DMListUseCase()
    
    init(workSpaceId: Int) {
        self.workSpaceId = workSpaceId
    }
    
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
        let loadData: PublishSubject<Void>
    }
    
    struct Output {
        let workSpaceImage: PublishSubject<String>
        let workSpaceMemberList: PublishSubject<[UserInfoModel]>
        let profileImage: PublishSubject<String>
        
        let dmRoomArr: PublishSubject<[DMChattingCellInfoModel]>
    }
    
    func transform(_ input: Input) -> Output {
        
        let workSpaceImage = PublishSubject<String>()
        let workSpaceMemberList = PublishSubject<[UserInfoModel]>()
        let profileImage = PublishSubject<String>()
        
        let dmRoomArr = PublishSubject<[DMChattingCellInfoModel]>()
        
        // 1. (내가 속한 워크스페이스 한 개 조회)
        input.loadData
            .flatMap {
                NetworkManager.shared.request(
                    type: MyOneWorkSpaceResponseDTO.self,
                    api: .myOneWorkSpace(self.workSpaceId)
                )
            }
            .subscribe(with: self) { owner , response in
                switch response {
                case .success(let dtoData):
                    print("// 1. (내가 속한 워크스페이스 한 개 조회)")
                    print(dtoData)
                    workSpaceImage.onNext(dtoData.thumbnail)
                    workSpaceMemberList.onNext(dtoData.workspaceMembers.map { $0.toDomain() })
                    
                case .failure(let error):
                    print("에러났슈 : \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        
        
        // 1. (내 프로필 정보 조회)
        input.loadData
            .flatMap {
                NetworkManager.shared.request(
                    type: MyProfileInfoDTO.self,
                    api: .myProfileInfo
                )
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let dtoData):
                    print("// 1. (내 프로필 정보 조회)")
                    print(dtoData)
                    profileImage.onNext(dtoData.profileImage ?? "")
                
                    
                case .failure(let error):
                    print("에러났슈 : \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        
        
        
        /* 디비에 한 번에 넣기 테스트
        let m = RealmManager()
        
        
        NetworkManager.shared.requestCompletion(
            type: MyDMsResponseDTO.self,
            api: .workSpaceDMs(152)) { response in
                switch response {
                case .success(let dtoData):
                    // 디엠 방 리스트 다 받았고,
                    
                    dtoData.forEach { dmRoomInfo in
                        
                        let dto = DMChattingRequestDTO(
                            partnerUserId: dmRoomInfo.user.user_id,
                            workSpaceId: 152,
                            cursorDate: ""
                        )
                        
                        NetworkManager.shared.requestCompletion(
                            type: DMChattingResponseDTO.self,
                            api: .dmChattings(dto)) { response in
                                switch response {
                                case .success(let dtoData):
                                    // 채팅 리스트 다 가져왔고,
                                    
                                    dtoData.chats.forEach { chat in
                                        m.addDMChattingData(
                                            dtoData: chat,
                                            workSpaceId: 152
                                        )
                                    }
                                    
                                    
                                case .failure:
                                    break
                                }
                            }
                    }
                    
                case .failure:
                    break
                    
                }
            }
         */
        
    
        
        
        // 1. (DM 방 조회)
        input.loadData
            .flatMap {
                self.dmListUseCase.fetchDMList(self.workSpaceId)
            }
            .subscribe(with: self) { owner , response in
                switch response {
                case .success(let arr):
                    let sortedArr = arr.sorted {
                        $0.lastDate > $1.lastDate
                    }
                    dmRoomArr.onNext(sortedArr)
                    print("**********")
                    sortedArr.forEach { item in
                        print(item)
                        print("")
                    }
                    print("**********")
                    
                case .failure:
                    break
                }
                
            }
            .disposed(by: disposeBag)
 
        
        
        
        return Output(
            workSpaceImage: workSpaceImage,
            workSpaceMemberList: workSpaceMemberList,
            profileImage: profileImage,
            dmRoomArr: dmRoomArr
        )
    }
}
