//
//  ExploreChannelViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

// 필요한 네트워크
// 1. 채널 모두 불러오기
// 2. 특정 채널에 내가 속해있는지 확인하기

// 3. 특정 채널에 조인하기 -> 채팅 보면 알아서 조인된다. 즉, 화면전환 시키고 네트워크 콜 쏘자
// -> 굳이 1. 조인하기, 2. 채팅 조회하기 이렇게 나눠두지 않은 것 같음.

class ExploreChannelViewModel: BaseViewModelType {
    
    private var workSpaceId: Int
    private var exploreChannelUseCase: ExploreChannelUseCaseProtocol
    
    private var disposeBag = DisposeBag()
    
    var didSendEventClosure: ( (ExploreChannelViewModel.Event) -> Void )?

    
    init(workSpaceId: Int, exploreChannelUseCase: ExploreChannelUseCaseProtocol) {
        self.workSpaceId = workSpaceId
        self.exploreChannelUseCase = exploreChannelUseCase
    }
    
    
    
    struct Input {
        let loadData: PublishSubject<Void>
        let itemSelected: ControlEvent<IndexPath>
        let joinChannel: PublishSubject<String> // 채널은 이름 가지고 통신함
    }
    struct Output {
        let items: PublishSubject<[WorkSpaceChannelInfoModel]>
        // 내가 채널에 속해 있지 않은 경우, 이걸로 채널 이름을 이벤트로 보낸다.
        let notJoinedChannel: PublishSubject<WorkSpaceChannelInfoModel>
    }
    
    func transform(_ input: Input) -> Output {
        
        let items = PublishSubject<[WorkSpaceChannelInfoModel]>()
        let notJoinedChannel = PublishSubject<WorkSpaceChannelInfoModel>()
        
        
        // 데이터 로드
        input.loadData
            .flatMap {
                self.exploreChannelUseCase.allChannelRequest(self.workSpaceId)
            }
            .subscribe(with: self) { owner , response  in
                switch response {
                case .success(let model):
                    items.onNext(model)
                    
                case .failure(let error):
                    print("에러났슈 : \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        
        var selectedChannel = WorkSpaceChannelInfoModel(channelId: 0, name: "")
        
        input.itemSelected
            .withLatestFrom(items) { v1, v2 in
                
                selectedChannel = v2[v1.row]
                
                return ChannelDetailRequestModel(
                    workSpaceId: self.workSpaceId,
                    channelName: v2[v1.row].name
                )
            }
            .flatMap {
                self.exploreChannelUseCase.channelMembersRequest($0)
            }
            .subscribe(with: self) { owner , response in
                switch response  {
                case .success(let model):
                    // * 임시
                    if owner.exploreChannelUseCase.checkAlreadyJoinedChannel(userId: 154, memberArr: model) {
                        print("이미 소속된 채널이다")
                        
                        // 화면 전환 시켜주기
                        owner.didSendEventClosure?(.goChannelChatting(channelName: "하이"))
                        
                    } else {
                        print("소속되지 않은 채널이다")
                        notJoinedChannel.onNext(selectedChannel)
                    }
                    
                    
                case .failure(let networkError):
                    print("멤버 불러오는데 에러남 : \(networkError)")
                }
            }
        
            
        
        input.joinChannel
            .subscribe(with: self) { owner , value in
                print("채널 이름 \(value) 에 조인한다. 화면 전환")
                
                owner.didSendEventClosure?(.goChannelChatting(channelName: "하이"))
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            items: items,
            notJoinedChannel: notJoinedChannel
        )
    }
}

extension ExploreChannelViewModel {
    enum Event {
        case goChannelChatting(channelName: String)
    }
}
