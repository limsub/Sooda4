//
//  ChannelChattingViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa


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
    
    
    struct Input {
        let loadData: PublishSubject<Void>
        let channelSettingButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let b: String
    }
    
    func transform(_ input: Input) -> Output {
        
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
        
        return Output(b: "hi")
    }
}

extension ChannelChattingViewModel {
    enum Event {
        case goBackHomeDefault(workSpaceId: Int)
        case goChannelSetting(workSpaceId: Int, channelName: String)
    }
}
