//
//  ChannelChattingViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class SampleData {
    static let arr = [
        ChannelChattingDTO(channel_id: 203, channelName: "ㅎㅇㅎㅇ", chat_id: 11, content: "hihi", createdAt: "2024-01-07T11:28:59.124Z", files: [], user: UserInfoDTO(user_id: 100, email: "hihi", nickname: "hih", profileImage: nil)),
        
        ChannelChattingDTO(channel_id: 203, channelName: "ㅎㅇㅎㅇ", chat_id: 12, content: "fawefawefeawf", createdAt: "2024-01-02T11:28:59.124Z", files: [], user: UserInfoDTO(user_id: 100, email: "hihi", nickname: "hih", profileImage: nil)),
        
        ChannelChattingDTO(channel_id: 203, channelName: "ㅎㅇㅎㅇ", chat_id: 13, content: "q3ecqweqcrqwerc", createdAt: "2024-01-11T11:28:59.124Z", files: [], user: UserInfoDTO(user_id: 100, email: "hihi", nickname: "hih", profileImage: nil)),
        
        ChannelChattingDTO(channel_id: 203, channelName: "ㅎㅇㅎㅇ", chat_id: 14, content: "cqwrxe3q2e", createdAt: "2023-11-22T11:28:59.124Z", files: [], user: UserInfoDTO(user_id: 100, email: "hihi", nickname: "hih", profileImage: nil)),
        
        ChannelChattingDTO(channel_id: 203, channelName: "ㅎㅇㅎㅇ", chat_id: 15, content: "dyjytkjtyfkty", createdAt: "2023-12-22T11:28:59.124Z", files: [], user: UserInfoDTO(user_id: 100, email: "hihi", nickname: "hih", profileImage: nil)),
        
        ChannelChattingDTO(channel_id: 203, channelName: "ㅎㅇㅎㅇ", chat_id: 16, content: "dfxxdfgheshh5r", createdAt: "2024-01-21T11:28:59.124Z", files: [], user: UserInfoDTO(user_id: 100, email: "hihi", nickname: "hih", profileImage: nil)),
        
        ChannelChattingDTO(channel_id: 203, channelName: "ㅎㅇㅎㅇ", chat_id: 17, content: "5e7u6rdrfjdrtj", createdAt: "2024-01-19T11:28:59.124Z", files: [], user: UserInfoDTO(user_id: 100, email: "hihi", nickname: "hih", profileImage: nil))
    
    ]
}


class ChannelChattingViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    private var workSpaceId: Int
    private var channelName: String
    
    
    var didSendEventClosure: ( (ChannelChattingViewModel.Event) -> Void )?
    
    private var channelChattingUseCase: ChannelChattingUseCaseProtocol
    
    init(workSpaceId: Int, channelName: String, channelChattingUseCase: ChannelChattingUseCaseProtocol) {
        self.workSpaceId = workSpaceId
        self.channelName = channelName
        self.channelChattingUseCase = channelChattingUseCase
    }
    
    // 처음 들어왔을 때 -> 채팅 조회 api
    // 만약 아직 속해있지 않은 채널이라면 자동으로 속해진다.
    
    
    // 1. 디비에 저장된 마지막 날짜 확인 -> 날짜 변수에 저장
    // 2. 해당 날짜 이후 채팅내역 서버에서 가져옴
    // 3. 서버에서 가져온 후 바로 디비에 저장.
    // 4. 날짜 변수 기준 이전 30개, 이후 30개 데이터 로드
    // 5. 스크롤 시점은 날짜 셀.
    
    
    struct Input {
        let loadData: PublishSubject<Void>
        let channelSettingButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let b: String
    }
    
    let repo = ChannelChattingRepository()
    
    func transform(_ input: Input) -> Output {
        
        /* === 테스트 === */
        print("---------")
//        repo.printURL()
////        print(repo.checkLastDate(channelId: 203))
//        print("---------")
//        
////        let arr = SampleData.arr
////        repo.addData(dataList: arr)
//        
////        repo.fetchPreviousData(channelId: 203, targetDate: Date()).forEach { print($0) }
//        
//        
//        print(repo.fetchPreviousData(
//            channelName: "ㅎㅇㅎㅇ",
//            targetDate: Date()
//        ))
//        
//        repo.fetchNextData(
//            workSpaceId: self.workSpaceId,
//            channelName: self.channelName,
//            targetDate: Date()) { result in
//                print(result)
//            }
        
        
        print("---------")
        /* ============ */
        
        // 채널 채팅 조회
        let requestModel = ChannelChattingRequestModel(
            workSpaceId: self.workSpaceId,
            channelName: self.channelName,
            cursor_date: "" // Date().toString(of: .dateToTime)
        )

        input.loadData
            .flatMap { _ in
                self.channelChattingUseCase.channelChattingRequest(requestModel)
            }
            .subscribe(with: self) { owner , response in
                
                switch response {
                case .success(let model):
                    print("채널 채팅 조회 네트워크 통신 성공")
                    print(model)
                    
                case .failure(let networkError):
                    print("채널 채팅 조회 네트워크 통신 실패")
                    print(networkError)
                }
            }
            .disposed(by: disposeBag)
        
        
        input.channelSettingButtonClicked
            .subscribe(with: self) { owner , _ in
                owner.didSendEventClosure?(.goChannelSetting(
                    workSpaceId: owner.workSpaceId,
                    channelName: owner.channelName
                ))
            }
            .disposed(by: disposeBag)
        
        return Output(b: "hi")
    }
    
    
    
    var lastChattingDate: Date?
    
    // 디비에 저장된 채팅의 마지막 날짜 저장
    func checkLastDate() {
        repo.printURL()
        
        let requesetModel = ChannelDetailRequestModel(
            workSpaceId: self.workSpaceId,
            channelName: self.channelName
        )
        
        self.lastChattingDate = channelChattingUseCase.checkLastDate(
            requestModel: requesetModel
        )
        print("확인한 채팅 중 가장 마지막 날짜 : ", lastChattingDate)
    }
    
    
    // lastChattingDate 이후 온 채팅을 디비에 저장한다.
    // 이 때, 동시에 소켓이 오픈되기 때문에 해당 채팅이 이미 디비에 있는지 확인하는 작업이 필요하다
    func fetchRecentChatting(completion: @escaping () -> Void) {
        
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
            channelChattingRequestModel: requestModel) { result  in
                
                print("결과 - 성공일 때는 이미 디비에 넣는 작업까지 repo에서 하기 때문에 completion이 필요없다")
                print(result)
                
                self.fetchAllPastChatting {
                    print("hihi")
                }
            }
        
        // 소켓 오픈
        self.openSocket()
    }
    
    func openSocket() {
        print("소켓 오픈")
    }
    
    
    // 이제 테이블뷰에 띄울 데이터 배열에 대한 관리 시작
    // 1. 앞에 (최대) 30개는 lastChattingDate를 포함한 읽은 채팅
    // 2. 가운데 하나는 "여기까지 읽었습니다" 셀에 적용할 mock 데이터 하나
    // 3. 뒤에 (최대) 30개는 lastChattingDate를 포함하지 않은 읽은 채팅
    // 1, 3 모두 realm에서 가져온다
    var chatArr: [ChattingInfoModel] = []
    func fetchAllPastChatting(completion: @escaping () -> Void) {
        print("-- chatArr에 데이터 추가 --")
        
        // 1.
        let previousArr = repo.fetchPreviousData(
            workSpaceId: self.workSpaceId,
            channelName: self.channelName,
            targetDate: self.lastChattingDate
        )
        chatArr.append(contentsOf: previousArr)
        
        
        // 2. 이걸 어떻게 기본 데이터로 만들지 -> 일단 대충
        let seperatorData = ChattingInfoModel(
            content: "기본 데이터",
            createdAt: Date(),
            files: [],
            userName: "기본 데이터",
            userImage: "기본 데이터"
        )
        chatArr.append(seperatorData)
        
        
        // 3.
        let nextArr = repo.fetchNextData(
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
