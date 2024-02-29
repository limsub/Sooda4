//
//  DMListViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import Foundation
import RxSwift
import RxCocoa

let sampleNameArr = [
    "Sophia", "Liam", "Chloe", "Noah", "Oliver", "Lucas", "Aria", "Luna", "James", "Alexandar", "Michael", "Madison", "Benjamin", "Mason"/*, "Elizabeth", "Scarlett"*/
]

let sampleSentenceArr = [
    "Hello, How can I help?",
    "Any specific issue?",
    "Checking, please wait.",
    "Need more details.",
    "Trouble understanding, clarify?",
    "Elaborate on your issue.",
    "Resolving issue shortly.",
    "Need additional assistance?",
    "Providing update shortly.",
    "More info, please?",
    "Discussing next steps.",
    "Any other requests?",
    "Thanks for the update.",
    "Seeking optimal solution.",
    "More info required.",
    "Reviewing, will respond.",
    "Other concerns? Ask.",
    "Need more help?",
    "Striving for better.",
    "Issue persists? Inform.",
]

class DMListViewModel: BaseViewModelType {
    
    var index = 0

    lazy var samplDMListeArr: [DMListSectionData] = sampleNameArr.map {
        
        
        
//        var dateComponent = DateComponents()
//        dateComponent.day = Int.random(in: -40...0)
//        let sampleDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
        
        let sentence = sampleSentenceArr[index]
        let sampleDate = Calendar.current.date(byAdding: DateComponents(day: index * (-1)), to: Date())!
        
        index += 1
        
        return DMListSectionData(header: "1", items: [
            DMChattingCellInfoModel(
                roomId: 0,
                userInfo: UserInfoModel(
                    userId: 0,
                    email: "",
                    nickname: $0,
                    profileImage: ""
                ),
                lastContent: sentence,
                lastDate: sampleDate,
                unreadCount:(index >= 7) ? 0 :  Int.random(in: 0...12)
            )
        ])
    }
    
    var sampleUserListArr: [UserInfoModel] = sampleNameArr.map {
        UserInfoModel(
            userId: 0,
            email: "",
            nickname: $0,
            profileImage: ""
        )
    }
    
    
    let workSpaceId: Int
    
    private var disposeBag = DisposeBag()
    
    let dmListUseCase = DMListUseCase()
    
    init(workSpaceId: Int) {
        self.workSpaceId = workSpaceId
    }
    
    let dmRoomSectionsArr = BehaviorSubject<[DMListSectionData]>(value: [])
    
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

/*
        // * test button : 특정 채팅이 푸시알림으로 왔을 때, 해당 채팅방을 맨 위로 보내준다.
//        var sampleRoomId = 12   // 특정 채팅방의 room id
        input.testButtonClicked
            .subscribe(with: self) { owner , _ in
                guard var modifiedValue = try? owner.dmRoomSectionsArr.value() else { return }
                
//                let targetRoomId = sampleRoomId
//                
//                // 1. 배열에서 해당 채팅방을 찾는다
//                guard let targetIndex = modifiedValue[0].items.firstIndex(where: { $0.roomId == targetRoomId }) else { return }
                
                let targetIndex = 2
                
                // 2. 해당 요소를 제거한다
                let removedElement = modifiedValue[0].items.remove(at: targetIndex)
                owner.dmRoomSectionsArr.onNext(modifiedValue)
                
                
                // 3. 배열의 맨 앞에 삽입한다
                modifiedValue[0].items.insert(removedElement, at: 0)
                owner.dmRoomSectionsArr.onNext(modifiedValue)
            }
            .disposed(by: disposeBag)
*/
        
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
                    
                    /* 임시 */
//                    workSpaceMemberList.onNext(
//                        dtoData.workspaceMembers
//                            .map { $0.toDomain() }
//                            .filter { $0.userId != KeychainStorage.shared._id }
//                    )  // 본인 제외
                    
                    workSpaceMemberList.onNext(self.sampleUserListArr)
                    
                    
                    
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
                    
                    
                    /* 임시 */
//                    owner.dmRoomSectionsArr.onNext(sectionArrData)
                    owner.dmRoomSectionsArr.onNext(self.samplDMListeArr)
                    
//                    dmRoomArr.onNext(sortedArr)
                    print("**********")
                    sortedArr.forEach { item in
                        print(item)
                        print("")
                    }
                    print("**********")
                    print(try! owner.dmRoomSectionsArr.value())
                    print("**********")
                    
                    
                case .failure:
                    break
                }
                
            }
            .disposed(by: disposeBag)
 
        
        
        
        // Push Notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveDMChattingPushNotification),
            name: Notification.Name("receiveDMChattingPushNotification"),
            object: nil
        )
        

        
        
        
        return Output(
            workSpaceImage: workSpaceImage,
            workSpaceMemberList: workSpaceMemberList,
            profileImage: profileImage,
            dmRoomSectionsArr: dmRoomSectionsArr
        )
    }
    
    
    
    @objc private func receiveDMChattingPushNotification(_ notification: Notification) {
        
        print("*****")
        
        
        if let userInfo = notification.userInfo,
           let opponentId = userInfo["opponentId"] as? Int,
           let workspaceId = userInfo["workspaceId"] as? Int,
           let content = userInfo["content"] as? String,
           let opponentName = userInfo["opponentName"] as? String
        {
            print("opponentId : \(opponentId), workspaceId : \(workspaceId)")
            print("content: \(content), oppoonentName: \(opponentName)")
            // opponent id 가지고 배열에서 찾을거야
            
            // content는 알림에서 준 거 쓰고, 시간은 어쩔 수 없이 현재 시간 직접 계산해야 할 것 같아
            
            do {
                var newArr = try self.dmRoomSectionsArr.value()
                
                var targetIndex: Int = 0
                
                for i in 0..<newArr[0].items.count {
                    if newArr[0].items[i].userInfo.userId == opponentId {
                        print("푸시 알림 온 디엠 채팅방 찾음. 이걸 배열의 맨 앞으로 올린다")
                        targetIndex = i
                        break

                    }
                }
                
                var newItem = newArr[0].items.remove(at: targetIndex)
                newItem.lastDate = Date()
                newItem.lastContent = content
                newItem.unreadCount += 1
                
                self.dmRoomSectionsArr.onNext(newArr)
                
                
                newArr[0].items.insert(newItem, at: 0)
                self.dmRoomSectionsArr.onNext(newArr)
            
                

                
            } catch {
                print("에러에러에러")
            }
            
    
        
            
            // opo
        }
        
    }
    
    
    
}


extension DMListViewModel {
    // 채널 or 디엠 채팅 디코딩
    private func decodingData<T: Decodable>(userInfo: [String: Any]) -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: userInfo),
           let decodedData = try? JSONDecoder().decode(T.self, from: jsonData) {
            return decodedData
        }
        
        return nil
    }
}
