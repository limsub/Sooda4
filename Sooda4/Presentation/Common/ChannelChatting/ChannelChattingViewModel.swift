//
//  ChannelChattingViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

enum ResultMakeChatting {
    case success(model: ChattingInfoModel)
    case failure(networkError: NetworkError)
}


class ChannelChattingViewModel {
    
    private var disposeBag = DisposeBag()
    
    private var workSpaceId: Int
    var channelId: Int
    private var channelName: String
    
    
    private var lastChattingDate: Date? // 안읽은 채팅의 기준이 되는 날짜. (얘 포함 이전 날짜)
    private var chatArr: [ChattingInfoModel] = []   // 채팅 테이블뷰에 보여줄 데이터
//    var seperatorIndex: Int?    // "여기까지 읽었습니다" 셀이 들어갈 위치
    
    var didSendEventClosure: ( (ChannelChattingViewModel.Event) -> Void )?
    
    let imageData = BehaviorSubject<[Data]>(value: [])    // 이미지 저장
    
    private var addNewChatData = PublishSubject<ChattingInfoModel>()
    
    
    // 현재 스크롤 위치에 대한 정보 -> newMessageToastView 띄울 때 사용
    private var isScrollBottom = false
    var yPos: CGFloat = 0
    var delta: CGFloat = 0
    
    // Pagination 변수 -> 다른 화면 갔다오면 네트워크 콜 다시 들어가기 때문에 또 초기화해줘야 함
    private var stopPreviousPagination = false, stopNextPagination = false, isDonePreviousPagination = false, isDoneNextPagination = false
    private var previousOffsetTargetDate: Date? = nil
    private var nextOffsetTargetDate: Date? = nil
    
    var notLoadScrollPagination = true  // 일단 초기 데이터를 다 부르고, 테이블뷰가 안정화된 다음에 didScroll로 인한 pagination이 실행되어야 함. 뷰 로드 되자마자 오두방정 떨어버리면 배열 난리난다.
    
    
    
    private var channelChattingUseCase: ChannelChattingUseCaseProtocol
    
    
    init(workSpaceId: Int, channelId: Int, channelName: String, channelChattingUseCase: ChannelChattingUseCaseProtocol) {
        
        print("---------- 채널 정보 ----------")
        print("workspace_id: \(workSpaceId) / channel_id : \(channelId)")
        self.workSpaceId = workSpaceId
        self.channelId = channelId
        self.channelName = channelName
        self.channelChattingUseCase = channelChattingUseCase
    }
    
    
    
    /* ===== Input / Output Pattern ===== */
    // - 채팅 생성 (텍스트, 이미지, 버튼 클릭)
    // - 세팅 화면 전환
    struct Input {
        let chattingText: ControlProperty<String>
        let sendButtonClicked: ControlEvent<Void>
        
        let channelSettingButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let showImageCollectionView: BehaviorSubject<Bool> // 선택한 이미지가 1개 이상이면 컬렉션뷰 보여준다
        let enabledSendButton: BehaviorSubject<Bool> // 텍스트가 입력되었거나 이미지가 있으면 버튼 활성화
        let resultMakeChatting: PublishSubject<ResultMakeChatting>  // 채팅 성공 시 뷰컨에서 처리해줄 일 해주기
        let addNewChatData: PublishSubject<ChattingInfoModel>    // 소켓 채팅 응답 시 뷰컨에 이벤트 전달
    }
    
    func transform(_ input: Input) -> Output {
        
        let showImageCollectionView = BehaviorSubject(value: false)
        let enabledSendButton = BehaviorSubject(value: false)
        let resultMakeChatting = PublishSubject<ResultMakeChatting>()
        
        
        // 1. 선택한 이미지가 있으면 컬렉션뷰를 보여준다.
        self.imageData
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: showImageCollectionView)
            .disposed(by: disposeBag)
        
        
        // 2. 선택한 이미지가 있거나 or 텍스트가 입력이 되었다면 버튼 활성화
        //   - 둘 다 초기 이벤트가 있기 때문에 combinelatest가 가능하다.
        Observable.combineLatest(input.chattingText, imageData) { v1, v2 in
            return self.isStringEnabled(str: v1) || !v2.isEmpty
        }
        .bind(to: enabledSendButton)
        .disposed(by: disposeBag)
        
        
        // 3. 전송 버튼 클릭
        input.sendButtonClicked
            .withLatestFrom(Observable.combineLatest(input.chattingText, imageData)) { _, values in

                return MakeChannelChattingRequestModel(
                    channelName: self.channelName,
                    workSpaceId: self.workSpaceId,
                    content: values.0,
                    files: values.1
                )
            }
            .flatMap {
                self.channelChattingUseCase.makeChatting($0)
            }
            .subscribe(with: self) { owner , response in
                switch response {
                case .success(let model):
                    // 채팅 보내기 성공 TODO
                    // 1. (VM) 보낸 채팅 테이블뷰 업데이트 -> 배열에 추가
                    // 1.5 (VC) 테이블뷰 reload
                    // 2. (REPO) 보낸 채팅 디비에 바로 저장
                    // 3. (VC) 테이블뷰 스크롤 위치 맨 아래로 이동 (방금 보낸 채팅 보이게 하기)
                    // 4. (VC) input view 초기화 (텍스트, 이미지)
                    
                    print("전송 성공")
                    print(model)
                    
                    // 1.
                    owner.chatArr.append(model)
                    
                    // 2.
                    
                    
                    
                    // 결과 전달
                    resultMakeChatting.onNext(.success(model: model))
                    
                case .failure(let networkError):
                    print("에러발생 : \(networkError)")
                    resultMakeChatting.onNext(.failure(networkError: networkError))
                    
                }
            }
            .disposed(by: disposeBag)
        
        
        // 4. 채널 세팅 화면으로 넘어간다. -> HomeDefault에서 바로 넘어온 경우 아직 구현 x
        input.channelSettingButtonClicked
            .subscribe(with: self) { owner , _ in
                owner.didSendEventClosure?(.goChannelSetting(
                    workSpaceId: owner.workSpaceId,
                    channelName: owner.channelName
                ))
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            showImageCollectionView: showImageCollectionView,
            enabledSendButton: enabledSendButton,
            resultMakeChatting: resultMakeChatting,
            addNewChatData: self.addNewChatData
        )
    }
    

    
    
    
    /* ===== Completion ===== */
    // 처음 들어왔을 때 -> 채팅 조회 api
    // 만약 아직 속해있지 않은 채널이라면 자동으로 속해진다.
    
    // - 채팅 데이터 (테이블뷰)
    func loadData(completion: @escaping () -> Void) {
        // 1. 디비에 저장된 채팅의 마지막 날짜
        self.checkLastChattingDate()
        
        // 2. 안읽은 채팅 API call -> 디비에 저장
        // 2. 소켓 오픈
        self.fetchRecentChatting {
            
            // 3. 디비에서 데이터 가져와서 chatArr 구성
            // (이전 (포함) 30 + sample + 이후 30)
            self.fetchAllPastChatting()
            completion()    // 아마 tableView reload
            
            // 4. 이제부터 스크롤에 따라 pagination 시작
            print("이제부터 스크롤에 따라 pagination 시작")
            self.notLoadScrollPagination = false
        }
    }
}


// 채팅 데이터 불러오는 로직
extension ChannelChattingViewModel {
    // 1. 디비에 저장된 마지막 날짜 확인 -> 날짜 변수에 저장
    // 2. 해당 날짜 이후 채팅내역 서버에서 가져옴 -> 디비에 저장
    // 3. 날짜 변수 기준 이전 30개, 이후 30개 데이터 로드
    // 4. tableView reload & scroll offset 지정
    
    
    // 1.
    private func checkLastChattingDate() {
        
        let requestModel = ChannelDetailFullRequestModel(
            workSpaceId: self.workSpaceId,
            channelId: self.channelId,
            channelName: self.channelName
        )
        
        self.lastChattingDate = channelChattingUseCase.checkLastDate(
            requestModel: requestModel
        )
 
        print("확인한 채팅 중 가장 마지막 날짜 : ", lastChattingDate)
    }

    // 2.
    private func fetchRecentChatting(completion: @escaping () -> Void) {
        
        // 모델 생성
        var requestModel: ChannelChattingRequestModel
        
        if var targetDate = lastChattingDate {
            // * 임시 : 1ms 더해서 네트워크 콜 쏜다. (v2에서 바뀔 예정)
//            var dateComponents = DateComponents()
//            dateComponents.second = 1
//            targetDate = Calendar.current.date(byAdding: dateComponents, to: targetDate)!
            // -> 디비 저장 시 이미 디비에 저장된 채팅인지 체크하는 로직 추가
            
            requestModel = ChannelChattingRequestModel(
                workSpaceId: workSpaceId,
                channelName: channelName,
                cursor_date: targetDate.toString(of: .toAPI)
            )
        } else {
            requestModel = ChannelChattingRequestModel(
                workSpaceId: workSpaceId,
                channelName: channelName,
                cursor_date: Date().toString(of: .toAPI)
                // 기존에 빈 문자열 넣는 거에서 수정.
                // 만약 채팅방을 새로 들어가서 디비에 읽은 애들이 없다면, 얘가 소속되기 전 채팅들은 굳이 네트워크 콜로 보낼 필요가 없다.
                // -> cursor Date를 그 순간의 시간으로 넣어주면 기존 채팅 내역들은 안볼 수 있다.
            )
        }
        
        // 네트워크 통신
        channelChattingUseCase.fetchRecentChatting(
            channelChattingRequestModel: requestModel,
            completion: completion
        )
        
        // 소켓 오픈 및 응답 대기
        self.openSocket()
        self.receiveSocket()
    }
    
    
    
    // 3.
    private func fetchAllPastChatting() {
        // 이제 테이블뷰에 띄울 데이터 배열에 대한 관리 시작
        // 1. 앞에 (최대) 30개는 lastChattingDate를 포함한 읽은 채팅
        // 2. 가운데 하나는 "여기까지 읽었습니다" 셀에 적용할 mock 데이터 하나
        // 3. 뒤에 (최대) 30개는 lastChattingDate를 포함하지 않은 읽은 채팅
        // 1, 3 모두 realm에서 가져온다
        
        print("-- chatArr에 데이터 추가 --")
        
        // 1.
        self.fetchPreviousData(self.lastChattingDate, isFirst: true)
        // 새롭게 받아온 개수가 몇개인지 리턴하지만, 이건 pagination할 때 insertRows 때문에 필요한거고, 여기선 받고나서 tableView reload를 해버리기 때문에 반환값을 사용할 일이 없다
        
        // 2.
        let seperatorData = ChattingInfoModel(
            content: "기본 데이터",
            createdAt: Date(),
            files: [],
            userId: -1,
            userName: "기본 데이터",
            userImage: "기본 데이터"
        )
        chatArr.append(seperatorData)
//        self.seperatorIndex = chatArr.count - 1
        
        
        // 3.
        self.fetchNextData(self.lastChattingDate)
        // 이하동문

    }
}

// Pagination
extension ChannelChattingViewModel {
    // 위로 pagination
    func paginationPreviousData(completion: @escaping (Int) -> Void) {
        // 0. 걸러
        if stopPreviousPagination || isDonePreviousPagination { return }
        
        // 1. 일단 과호출 막아
        self.stopPreviousPagination = true
        
        // 2. 디비에서 끄내
        let newArrCnt = self.fetchPreviousData(previousOffsetTargetDate, isFirst: false)
        
        // 3. tableView reload
        completion(newArrCnt)
        
        // 4. stop 풀어줘
        self.stopPreviousPagination = false
    }
    
    
    // 아래로 pagination
    func paginationNextData(completion: @escaping (Int) -> Void) {
        // 0. 걸러유~
        if stopNextPagination || isDoneNextPagination { return }
        
        // 1. 일단 과호출 막아유~
        self.stopNextPagination = true
        
        // 2. 디비에서 끄내유~
        let newArrCnt = self.fetchNextData(nextOffsetTargetDate)
        
        // 3. tableView reload유~~
        completion(newArrCnt)
        
        // 4. stop 풀어줘
        self.stopNextPagination = false
    }
    
}

// private func
extension ChannelChattingViewModel {
    // 1. 초기 데이터 불러올 때      2. pagination할 때
    
    // target date 이전으로 n개의 채팅 내역 불러와서 chatArr 맨 앞에 붙임
    private func fetchPreviousData(_ targetDate: Date?, isFirst: Bool) -> Int {
        
        let requestModel = ChannelDetailFullRequestModel(
            workSpaceId: self.workSpaceId,
            channelId: self.channelId,
            channelName: self.channelName
        )
        
        let previousArr = channelChattingUseCase.fetchPreviousData(
            requestModel: requestModel,
            targetDate: targetDate,
            isFirst: isFirst
        )
        
        // offset target date 지정 - 받아온 데이터들의 맨 첫 번째 채팅의 날짜
        previousOffsetTargetDate = previousArr.first?.createdAt
        
        // 배열 앞에 추가
        chatArr.insert(contentsOf: previousArr, at: 0)
        
        // 더이상 pagination이 가능한지 여부 판단
        isDonePreviousPagination = previousArr.isEmpty
        
        
        print("----- fetchPreviousData 실행 결과 isFirst : \(isFirst) -----")
        previousArr.forEach { chat in
            print("\(chat.createdAt)  \(chat.content)  \(chat.userName)")
        }
        print("이제 pagination 불가능? : \(isDonePreviousPagination)")
        print("----------------------------------------------------------")
        
        return previousArr.count
    }
    
    // targetDate 이후로 n개의 채팅 내역 불러와서 chatArr 맨 뒤에 붙임
    private func fetchNextData(_ targetDate: Date?) -> Int {
        
        let requestModel = ChannelDetailFullRequestModel(
            workSpaceId: self.workSpaceId,
            channelId: self.channelId,
            channelName: self.channelName
        )
        
        let nextArr = channelChattingUseCase.fetchNextData(
            requestModel: requestModel,
            targetDate: targetDate
        )
        
        // offset target date 지정 - 받아온 데이터들의 맨 마지막 채팅의 날짜
        nextOffsetTargetDate = nextArr.first?.createdAt
        
        // 배열 뒤에 추가
        chatArr.append(contentsOf: nextArr)
        
        // 더 이상 pagination이 가능한지 여부 판단
        isDoneNextPagination = nextArr.isEmpty
        
        print("--------------- fetchNextData 실행 결과 ---------------")
        nextArr.forEach { chat in
            print("\(chat.createdAt)  \(chat.content)  \(chat.userName)")
        }
        print("이제 pagination 불가능? : \(isDoneNextPagination)")
        print("----------------------------------------------------------")
        
        // 배열 pagination을 할 때 insert row로 하기 때문에 새롭게 추가된 배열 개수를 전달해줌
        return nextArr.count
    }
    
}


// VC
extension ChannelChattingViewModel {
    // 채널 이름
    func nameOfChannel() -> String {
        return self.channelName
    }
    
    // 채팅 아이템의 개수
    func numberOfRows() -> Int {
        return chatArr.count
    }
    
    // 이미지 데이터 초기화
    func removeAllImages() {
        self.imageData.onNext([])
    }
    
    // seperator cell의 위치
//    func isSeperatorCell(_ indexPath: IndexPath) -> Bool {
////        return indexPath.row == self.seperatorIndex // 옵서널 처리를 알아서 해주나봄
//    }
    
    // seperator cell의 위치 (인덱스) - 계속해서 indexPath가 바뀌기 때문에 (위로 pagination) 단순 변수로 저장해두는 것보다, 필요할 때마다 메서드로 계산하는게 더 낫다
    func seperatorCellIndex() -> Int {
        return chatArr.firstIndex { model in
            model.userId == -1
        } ?? 0
    }
    
    // cell에 그릴 데이터
    func dataForRowAt(_ indexPath: IndexPath) -> ChattingInfoModel {
        return chatArr[indexPath.row]
    }
    
    // 소켓 연결 해제
    func disconnectSocket() {
        self.closeSocket()
    }
    
    // 스크롤 시점 전달받음 (bottom 여부)
    func setUpIsScrollBottom(_ value: Bool) {
        self.isScrollBottom = value
    }
    
    // 스크롤 시점 전달해줌 (bottom 여부)
    func showNewMessageToast() -> Bool {
        return !self.isScrollBottom     // 스크롤이 위에 있으면 toastView 띄운다
    }
}

// Socket
extension ChannelChattingViewModel {
    // 소켓 연결
    private func openSocket() {
        print("소켓 연결")
        channelChattingUseCase.openSocket(self.channelId)
    }
    
    // 소켓 해제
    private func closeSocket() {
        print("소켓 연결 해졔")
        channelChattingUseCase.closeSocket()
    }
    
    // 응답
    private func receiveSocket() {
        channelChattingUseCase.receiveSocket(
            self.channelId) { newData  in
                print("소켓 응답!!!!! ", newData)
                
                print("user ID 확인해서 내가 아닐 때만 배열 뒤에 붙여줌")
                if newData.userId == KeychainStorage.shared._id { return }
                
                
                // 아직 아래 페이지네이션이 모두 되어있지 않은 상태라면, 배열 뒤에 붙이지 않는다. (디비에만 저장)
                // 대신, toastChatData에 값을 넣어서, 토스트 메세지로 뜨게 해준다.
                self.chatArr.append(newData)
                self.addNewChatData.onNext(newData)
            }
    }
}


// private func
extension ChannelChattingViewModel {
    private func isStringEnabled(str: String) -> Bool {
        let trimmedString = str.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !trimmedString.isEmpty
    }
}

// Event
extension ChannelChattingViewModel {
    enum Event {
        case goBackHomeDefault(workSpaceId: Int)
        case goChannelSetting(workSpaceId: Int, channelName: String)
    }
}

