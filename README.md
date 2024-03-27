![01 Header](https://github.com/limsub/Sooda4/assets/99518799/faeee90c-68b2-40bb-ae18-b131f50cb3a2)


## 💬 Sooda
> 서비스 소개 : 워크스페이스, 채널, DM 채팅 앱<br>
개발 인원 : 1인<br>
개발 기간 : 2024.01.01 ~ 2024.02.08<br>
협업 툴 : Figma, Confluence, Swagger<br>
협업 일지 : 


<br>


## 📚 Tech Blog
- [채팅 UI 구현](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-26%EC%A3%BC%EC%B0%A8)
- [채팅 로직 구현](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-27%EC%A3%BC%EC%B0%A8)
- [채팅 구현 과정에서 고민했던 지점](https://velog.io/@s_sub/12)
- [Push Notification](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-23%EC%A3%BC%EC%B0%A8)
- [Clean Architecture 적용기](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-24%EC%A3%BC%EC%B0%A8)
- [Coordinator Pattern 적용기](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-25%EC%A3%BC%EC%B0%A8)


<br>


## 🛠 기술 스택
- UIKit, RxSwift
- Clean Architecture, MVVM-C
- Alamofire, SocketIO, Realm
- KingFisher, SnapKit, SideMenu, RxDataSources
- AuthenticationServices, KakaoSDK
- PHPicker, UIDocumentPicker, UIDocumentInteraction, FileManager
- FirebaseMessaging, iamport-ios


<br>


## 💪 핵심 기능
- **회원 관리** (소셜 로그인 / 이메일 로그인 / 로그아웃 / deviceToken 업데이트)
- **워크스페이스** (생성 / 수정 / 삭제 / 퇴장 / 초대 / 권한 변경)
- **채널** (생성 / 수정 / 삭제 / 퇴장 / 채팅 생성 / 읽지 않은 채팅 개수 / 권한 변경)
- **DM** (채팅 생성 / 읽지 않은 채팅 개수)
- **푸시 알림** (실시간 채팅 응답)
- **PG 결제** (코인 구매)


<br>


## 💡 아키텍처
### Clean Architecture
![image](https://github.com/limsub/Sooda4/assets/99518799/b50668b7-69a1-48f3-a7e2-2b9e3faad2c3)
- 기존 VM의 비즈니스 로직을 UseCase와 Repository 로 분리
- 레이어 별 역할 분리 및 의존성 방향 유지
  



<br>


### MVVM - C
![‎Coordinator1 ‎001](https://github.com/limsub/Sooda4/assets/99518799/74619c45-97fd-4d51-8be5-0e12f0a267d1)
- View : 화면에 나타나는 뷰 객체
- VC : 사용자 interaction 및 View와 VM 연결
- VM : VC에 필요한 데이터 및 비즈니스 로직
- C : 화면 전환 로직


<br>


## 💻 구현 내용

- 파일명 다루기 (.pdf, .zip), mimetype, 이름 설정

### 1. 소셜 로그인 구현
- **AuthenticationServices** 를 이용한 애플 로그인 구현
- **KakaoSDK (Rx)** 를 이용한 카카오 로그인 구현


<br>


### 2. FCM Token을 이용한 Remote Push Notification 구현
- FCM Token 등록
  - `application.registerForRemoteNotifcations()` <br>
    - 앱 등록
  - `func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)`
    - deviceToken 수신
  - `Messaging.messaging().apnsToken = deviceToken` <br>
    - deviceToken 등록
  - `func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)`
    - fcmToken 수신
  - 서버에 fcmToken 전송


<br>


- 예외 사항
  - **사용자가 현재 화면으로 보고 있는 채팅방의 채팅은 푸시 알림으로 받지 않는다**
    - 현재 보고 있는 채팅방 정보를 `UserDefaults` 로 저장 후 예외처리
  - **푸시 알림 클릭 시, 해당 채팅방으로 화면 전환**
    - `NotificationCenter`를 이용해 AppDelegate에서 SceneDelegate로 채팅 정보 전달
    - `AppCoordinator`의 메서드 이용해서 화면 전환 구현


<br>


### 3. UITableView와 UITextView를 활용한 채팅 UI 구현
- Chatting Input View 구현<br>
  ![‎채팅6 ‎001](https://github.com/limsub/Sooda4/assets/99518799/baf0d125-575d-4b7d-bf29-cfd1dcf96771)



- Chatting TableView Cell 구현 <br>
  ![‎채팅2 ‎001](https://github.com/limsub/Sooda4/assets/99518799/e74769dd-0b3f-47b4-a844-a220d5dd6271)


- Seperator Cell 및 실시간 채팅 응답 toastView 구현 <br>
  ![‎채팅5 ‎001](https://github.com/limsub/Sooda4/assets/99518799/255d2032-07d3-4f96-a232-247c7253a999)



- 키보드 활성화 여부에 따라 채팅 화면 스크롤 이동
  |<img src="https://github.com/limsub/Sooda4/assets/99518799/099a301c-d3a4-4939-8846-758cfd8d635c" align="center" width="200">|<img src="https://github.com/limsub/Sooda4/assets/99518799/08942871-c502-4d46-a6fd-c42e7adde24e" align="center" width="200">|
  |:--:|:--:|
  |no input data|with input data|





<br>


### 4. 양방향 (Bidirectional) Cursor-Based Pagination 구현
- 상, 하단 Pagination을 위한 cursor targetDate 선언


- DB 데이터 추출
    ```swift
    // (상단 Pagnation) targetDate 이전 채팅 n개 추출
    return realm.objects(ChannelChattingInfoTable.self)
        .filter("channelInfo.channel_id == %@ AND createdAt < %@", channelID, targetDate)
        .sorted(byKeyPath: "createdAt")
        .suffix(n)
        .map { $0.toDomain() }


    // (하단 Pagination) targetDate 이후 채팅 n개 추출
    return realm.objects(ChannelChattingInfoTable.self)
        .filter("channelInfo.channel_id == %@ AND createdAt > %@", channelID, targetDate)
        .sorted(byKeyPath: "createdAt")
        .prefix(n)
        .map { $0.toDomain() }
    ```

- VM 배열 업데이트
    ```swift
    // (상단 Pagnation) VM 배열의 앞에 추가
    chatArr.insert(contentsOf: previousArr, at: 0)

    // (하단 Pagination) VM 배열의 뒤에 추가
    chatArr.append(contentsOf: nextArr)
    ```

- View 업데이트
    ```swift
    // (상단 Pagination) 
    let indexPaths = (0..<cnt).map { IndexPath(row: $0, section: 0) }
    tableView.insertRows(at: indexPaths, with: .bottom)

    // (하단 Pagination)
    tableView.reloadData()
    ```


<br>


### 5. Realm, HTTP, Socket 조합하여 채팅 기능 구현
- 채팅방 진입 시 초기 데이터 로딩 로직<br>
  ![‎채팅 ‎001](https://github.com/limsub/Sooda4/assets/99518799/1ccd93bb-444d-4e8b-914b-4e504efcc21e)


<br>


- 실시간 채팅 응답 및 전송 로직<br>
  ![‎채팅3 ‎001](https://github.com/limsub/Sooda4/assets/99518799/1cbe1c53-d752-4c96-81f7-90fddda45b39)
  - 하단 Pagination 완료 여부에 따라 세부 로직 분기 처리


<br>


### 6. RxDataSources AnimatableSectionModelType 를 이용한 채팅 리스트 화면 애니메이션 적용
- Push Notification (willPresent) 에서 NotificationCenter를 이용해 실시간 응답 채팅 정보 수신
- 일치하는 채팅방 데이터 탐색 후, 배열 업데이트
  
  |<img src="https://github.com/limsub/Sooda4/assets/99518799/dd6169d2-d247-4cd5-b537-020553e2e44b" align="center" width="200">|
  |:--:|
  |DMListView|


<br>


### 7. DataBase Normalization (BCNF)
![‎DB Table1 ‎001](https://github.com/limsub/Sooda4/assets/99518799/791bd013-16b8-44cc-bbc8-3075091ebaf9)
- 정규화 이전 : 채팅에 필요한 데이터를 모두 하나의 테이블에서 관리


- 정규화 필요성
  - **데이터 중복 최소화** : 유저 정보와 채널 정보가 채팅 테이블에 **중복으로 저장**
  - **데이터 일관성 유지** : 유저 정보 또는 채널 정보 수정 시 **모든 채팅에 대해 업데이트 필요**


- 정규화 진행
  - 2개의 테이블을 추가로 생성하고 채팅 테이블의 **FK 로 추가**
  - 테이블 내의 모든 FD(functional dependency)의 결정자가 Super Key
  <br>-> **BCNF** 만족


<br>


### 8. 로컬 및 서버 DB 동기화
- 유저 정보 또는 채널 정보가 서버에서 수정되었을 때, 로컬 DB (realm) 업데이트 필요


- 동기화 작업 하지 않으면 이슈 발생
  - 서로 다른 채널의 채팅이 섞임 (채널 이름 수정)
  - 같은 유저의 채팅 프로필이 다르게 보임 (유저 이름, 프로필 이미지 수정)


- 해결 : 채팅 화면에 들어가는 시점에, 최신 채널 정보와 유저 정보 네트워크 요청 -> 로컬 DB 업데이트
- 한계 : 채팅 화면을 보고 있는 상황에서 변경되는 데이터는 반영할 수 없음


<br>


## 🔥 트러블 슈팅


### 2. RxSwift 단일 stream에서의 다중 네트워크 비동기 처리
- DM 채팅방 리스트 불러오는 과정
    1. DM 채팅방 리스트 네트워크 요청 후 배열 초기화
    2. 배열의 각 요소(채팅방)에 대해 **읽지 않은 채팅 개수** 네트워크 요청 후 배열 업데이트


- RxSwift를 통해 네트워크 통신을 stream 내에서 관리하기 때문에 DispatchGroup 사용은 적절하지 않다고 판단


- `flatMap` 내부에서 Single 타입 결과를 저장하는 배열 생성 후 `Single.zip` 을 통해 결과를 조합한 최종 배열 반환

    ```swift
    // DMListUseCase
    func fetchDMList(_ workSpaceID: Int) -> Single<Result<[DMChattingCellInfoModel], NetworkError> > {
        
        return repo.fetchDMList(workSpaceID)  // (HTTP) 채팅방 리스트 네트워크 요청
            .flatMap { result -> Single< Result< [DMChattingCellInfoModel], NetworkError > > in
                
                switch result { // Result<[WorkSpaceDMInfoModel], NetworkError>
                    
                case .success(let dmInfoArr):
                    
                    /* Single 배열 생성 */
                    let singleArr: [Single< Result< DMChattingCellInfoModel, NetworkError > >] = dmInfoArr.map { dmInfo in

                                            let requestModel = /* ... */
                        
                        return self.repo.fetchLastChattingInfo(requestModel: requestModel)  // (HTTP) 마지막 채팅 정보 네트워크 요청
                        .flatMap { lastChatInfoResult -> Single< Result< DMChattingCellInfoModel, NetworkError> > in
                            
                            switch lastChatInfoResult { // Result<DMChattingModel, NetworkError>
                            case .success(let lastChatInfo):   
                                
                                let lastChattingDate = self.repo.fetchLastDMChattingDate(roomId: dmInfo.roomId)  // (Realm) 읽은 채팅 중 마지막 채팅 정보
                                
                                let requestModel = /* ... */
                                
                                return self.repo.fetchUnreadCountChatting(requestModel)  // (HTTP) 읽지 않은 채팅 개수 네트워크 요청
                                    .map { unreadCountResult -> Result<DMChattingCellInfoModel, NetworkError> in
                                        
                                        switch unreadCountResult {
                                        case .success(let unreadCountInfo):
                                            let ansModel = /* ... */ // 최종 결과 데이터 생성 (DMChattingCellInfoModel)
                                            return .success(ansModel)
                                            
                                        case .failure(let networkError):
                                            return .failure(networkError)
                                        }
                                    }
                                
                            case .failure(let networkError):
                                return Single.just(.failure(networkError))
                            }
                        }
                    }
                    
                                    /* Single 배열 조합 */
                    return Single.zip(singleArr)
                        .map { results -> Result<[DMChattingCellInfoModel], NetworkError> in
                            
                            let dmChattingCellInfoModels = results.compactMap { result -> DMChattingCellInfoModel? in
                                switch result {
                                case .success(let model):
                                    return model
                                case .failure:
                                    return nil
                                }
                            }
                            
                            return .success(dmChattingCellInfoModels)
                        }
                    
                case .failure(let networkError):
                    return Single.just(.failure(networkError))
                }   
            }   
    }
    ```


<br>


### 3. 다중 계정 환경에서 realm 관리 및 최적화
- 여러 계정이 로그인할 수 있는 환경에서 realm 파일을 하나로만 관리한다면 서로 다른 계정에서 같은 DB를 공유하는 이슈 발생


- 해결책 1 : 새로운 계정 로그인 시 DB 초기화
  - 매번 DB가 초기화되기 때문에 데이터가 공유되는 이슈 해결
  - 이슈 : 다른 계정으로 로그인 후 다시 이전 계정으로 로그인하면, 데이터가 모두 손실되기 때문에 이전 채팅 기록을 확인할 수 없다



- 해결책 2 : 계정 별 realm 파일 따로 생성
  - 각 계정별로 realm 파일을 따로 관리해서 데이터 공유와 손실 모두 방지


  - 이슈 : 로그인한 계정 수가 많아질수록 realm 파일이 그만큼 늘어나게 되고 용량 과부하
  - 해결 : realm 파일의 최대 개수 제한. 개수 초과 시 수정일이 가장 오래 된 파일 제거 **(LRU)**


- 계정 별 파일 생성
    ```swift
    // 키체인에 저장된 userID
    guard let userId = KeychainStorage.shared._id else {
        self.realm = nil
        return
    }

    let realmFileName = "SoodaRealm_user_\(userId).realm"
    let realmURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(realmFileName)
    let config = Realm.Configuration(fileURL: realmURL)

    self.realm = try! Realm(configuration: config)
    ```


- realm 파일 개수 제한
    ```swift
    private func checkRealmFileCount() {

        let fileManager = FileManager.default
        var realmFileDict: [String: [URL]] = [:]  // 각 계정 별 생성된 realm 파일들 저장
        
        do {
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let files = try fileManager.contentsOfDirectory(
                at: documentURL,
                includingPropertiesForKeys: [.contentModificationDateKey],
                options: .skipsHiddenFiles
            )
            
                    // 계정별 realm 파일들 Dictionary에 저장
            files.forEach { url in
                let fileName = url.deletingPathExtension().lastPathComponent
                
                if fileName.hasPrefix("SoodaRealm_user_") {
                    
                    var key = ""
                    
                    if let dotRange = fileName.range(of: ".") {
                        key = String(fileName[..<dotRange.lowerBound])
                    } else {
                        key = fileName
                    }
                                    
                    // 아직 없는 key이면 새로 만든다.
                    if realmFileDict[key] == nil {
                        realmFileDict[key] = []
                    }
                    
                    // dict에 url 추가
                    realmFileDict[key]?.append(url)
                }
            }
            
            
            if realmFileDict.keys.count > 5 {
                            // realm 파일이 5개 이상이면, 수정일이 가장 오래 된 파일 삭제 (LRU)
                
                if let oldestRealmFile = realmFileDict.min(by: { v1, v2 in
                    let modificationDate1 = (try? v1.value[1].resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                    let modificationDate2 = (try? v2.value[1].resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                    
                    return modificationDate1 < modificationDate2
                }) {
                    
                    for fileURL in oldestRealmFile.value {
                        do {
                            try fileManager.removeItem(at: fileURL)
                        } catch {
                            print("File Remove Error")
                        }
                    }
                }
            }
        } catch {
            print("FileManager Error")
        }
    }
    ```


<br>


## 🧭 회고
### 1. 일관적이지 않은 서버의 요청 모델
- 채널 ID (소켓), 채널 이름 (채팅 생성, 조회)
- DM room ID (채팅 생성), 상대방 userID (채팅 조회)

- DTO 사용의 장점


<br>


### 2. 채팅 구현 과정에서 다양한 고민 지점
- 소켓 연결 / 해제 시점에 대한 고민
  - viewDidAppear / viewDidDisappear
  - background / foreground
  - HTTP 통신 요청 완료 시점 vs. 응답 완료 시점


- 다중 계정 환경에서 DB 공유 이슈


- 멀티 디바이스 로그인 시 실시간 채팅 (소켓) 응답 조건 추가 필요
  - 단순 userID로만 분기 처리 -> 멀티 디바이스 대응 불가능
  - HTTP 전송 결과를 통해 분기 처리 -> 소켓 응답이 더 먼저 오기 때문에 비교 불가능


<br>


### 3. 채팅 화면에서 tableView와 키보드 스크롤 동기화


<br>


### 4. 새로운 아키텍처 도전 (Clean Architecture)
