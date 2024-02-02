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
        
        let testButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let workSpaceImage: PublishSubject<String>
        let workSpaceMemberList: PublishSubject<[UserInfoModel]>
        let profileImage: PublishSubject<String>
        
        let dmRoomSectionsArr: BehaviorSubject<[DMListSectionData]>  // 배열이긴 하지만 실질적으로 섹션 하나밖에 없다
    }
    
    func transform(_ input: Input) -> Output {
        
        let workSpaceImage = PublishSubject<String>()
        let workSpaceMemberList = PublishSubject<[UserInfoModel]>()
        let profileImage = PublishSubject<String>()
        let dmRoomSectionsArr = BehaviorSubject<[DMListSectionData]>(value: [])
        
        // * test button : 특정 채팅이 푸시알림으로 왔을 때, 해당 채팅방을 맨 위로 보내준다.
//        var sampleRoomId = 12   // 특정 채팅방의 room id
        input.testButtonClicked
            .subscribe(with: self) { owner , _ in
                guard var modifiedValue = try? dmRoomSectionsArr.value() else { return }
                
//                let targetRoomId = sampleRoomId
//                
//                // 1. 배열에서 해당 채팅방을 찾는다
//                guard let targetIndex = modifiedValue[0].items.firstIndex(where: { $0.roomId == targetRoomId }) else { return }
                
                let targetIndex = 2
                
                // 2. 해당 요소를 제거한다
                let removedElement = modifiedValue[0].items.remove(at: targetIndex)
                dmRoomSectionsArr.onNext(modifiedValue)
                
                
                // 3. 배열의 맨 앞에 삽입한다
                modifiedValue[0].items.insert(removedElement, at: 0)
                dmRoomSectionsArr.onNext(modifiedValue)
            }
            .disposed(by: disposeBag)

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
                    let sectionArrData = [DMListSectionData(header: "1", items: sortedArr)]
                    
                    dmRoomSectionsArr.onNext(sectionArrData)
                    
//                    dmRoomArr.onNext(sortedArr)
                    print("**********")
                    sortedArr.forEach { item in
                        print(item)
                        print("")
                    }
                    print("**********")
                    print(try! dmRoomSectionsArr.value())
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
            dmRoomSectionsArr: dmRoomSectionsArr
        )
    }
}
