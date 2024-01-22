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
        repo.printURL()
//        print(repo.checkLastDate(channelId: 203))
        print("---------")
        
//        let arr = SampleData.arr
//        repo.addData(dataList: arr)
        
//        repo.fetchPreviousData(channelId: 203, targetDate: Date()).forEach { print($0) }
        
        
        print(repo.fetchPreviousData(
            channelName: "ㅎㅇㅎㅇ",
            targetDate: Date()
        ))
        
        repo.fetchNextData(
            workSpaceId: self.workSpaceId,
            channelName: self.channelName,
            targetDate: Date()) { result in
                print(result)
            }
        
        
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
    
    
}

extension ChannelChattingViewModel {
    enum Event {
        case goBackHomeDefault(workSpaceId: Int)
        case goChannelSetting(workSpaceId: Int, channelName: String)
    }
}
