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
    case success
    case failure
}


class ChannelChattingViewModel {
    
    private var disposeBag = DisposeBag()
    
    private var workSpaceId: Int
    private var channelName: String
    
    var lastChattingDate: Date? // 안읽은 채팅의 기준이 되는 날짜. (얘 포함 이전 날짜)
    var chatArr: [ChattingInfoModel] = []   // 채팅 테이블뷰에 보여줄 데이터
    var seperatorIndex: Int?    // "여기까지 읽었습니다" 셀이 들어갈 위치
    
    var didSendEventClosure: ( (ChannelChattingViewModel.Event) -> Void )?
    
    let imageData = PublishSubject<[Data]>()    // 이미지 저장
    
    
    private var channelChattingUseCase: ChannelChattingUseCaseProtocol
    
    
    init(workSpaceId: Int, channelName: String, channelChattingUseCase: ChannelChattingUseCaseProtocol) {
        self.workSpaceId = workSpaceId
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
    }
    
    func transform(_ input: Input) -> Output {
        
        let showImageCollectionView = BehaviorSubject(value: false)
        let enabledSendButton = BehaviorSubject(value: false)
        let resultMakeChatting = PublishSubject<ResultMakeChatting>()
        
        
        // 선택한 이미지가 있으면 컬렉션뷰를 보여줘야 한다.
        
        
        
        
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
            resultMakeChatting: resultMakeChatting
        )
    }
    
//    let repo = ChannelChattingRepository()
    
    
    
    
    
    
    
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
        }
    }
    
    
    func sendMessage(content: String, files: [Data], completion: @escaping () -> Void) {
        
        channelChattingUseCase.makeChatting(
            MakeChannelChattingRequestModel(
                channelName: self.channelName,
                workSpaceId: self.workSpaceId,
                content: content,
                files: files
            )
        ) { response in
            print("----- 채팅 전송 결과 -----")
            print(response)
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
        self.lastChattingDate = channelChattingUseCase.checkLastDate(
            requestModel: ChannelDetailRequestModel(
                workSpaceId: self.workSpaceId,
                channelName: self.channelName
            )
        )
        print("확인한 채팅 중 가장 마지막 날짜 : ", lastChattingDate)
    }

    // 2.
    private func fetchRecentChatting(completion: @escaping () -> Void) {
        
        // 모델 생성
        var requestModel: ChannelChattingRequestModel
        
        if var targetDate = lastChattingDate {
            // * 임시 : 1ms 더해서 네트워크 콜 쏜다. (v2에서 바뀔 예정)
            var dateComponents = DateComponents()
            dateComponents.second = 1
            targetDate = Calendar.current.date(byAdding: dateComponents, to: targetDate)!
 
            
            requestModel = ChannelChattingRequestModel(
                workSpaceId: workSpaceId,
                channelName: channelName,
                cursor_date: targetDate.toString(of: .toAPI)
            )
        } else {
            requestModel = ChannelChattingRequestModel(
                workSpaceId: workSpaceId,
                channelName: channelName,
                cursor_date: ""
            )
        }
        
        // 네트워크 통신
        channelChattingUseCase.fetchRecentChatting(
            channelChattingRequestModel: requestModel,
            completion: completion
        )
        
        // 소켓 오픈
        self.openSocket()
    }
    
    private func openSocket() {
        print("소켓 오픈")
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
        let previousArr = channelChattingUseCase.fetchPreviousData(
            workSpaceId: self.workSpaceId,
            channelName: self.channelName,
            targetDate: self.lastChattingDate
        )
        chatArr.append(contentsOf: previousArr)
        
        
        // 2.
        let seperatorData = ChattingInfoModel(
            content: "기본 데이터",
            createdAt: Date(),
            files: [],
            userName: "기본 데이터",
            userImage: "기본 데이터"
        )
        chatArr.append(seperatorData)
        self.seperatorIndex = chatArr.count - 1
        
        
        // 3.
        let nextArr = channelChattingUseCase.fetchNextData(
            workSpaceId: self.workSpaceId,
            channelName: self.channelName,
            targetDate: self.lastChattingDate
        )
        chatArr.append(contentsOf: nextArr)
        
        
        print("---------- previousData ----------")
        previousArr.forEach { model in
            print(model)
        }
        print("---------- seperatorData ----------")
        print(seperatorData)
        print("---------- nextData ----------")
        nextArr.forEach { model in
            print(model)
        }
        
    }
}





extension ChannelChattingViewModel {
    enum Event {
        case goBackHomeDefault(workSpaceId: Int)
        case goChannelSetting(workSpaceId: Int, channelName: String)
    }
}
