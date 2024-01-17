//
//  MakeChannelViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

enum ResultMakeChannel {
    // 네트워크 콜 x
    case invalid    // 채널 이름 1 ~ 30
    
    // 네트워크 콜 o
    case success
    
    case failure(error: NetworkError)
    
    var toastMessage: String {
        switch self {
        case .invalid:
            return "채널 이름을 1 ~ 30자로 설정해주세요"
        case .success:
            return "Success"
        case .failure(let error):
            return "에러가 발생했습니다. 잠시 후에 다시 시도해주세요"
        }
    }
}


class MakeChannelViewModel: BaseViewModelType {
    
    enum OperationType {
        case make
        case edit(workSpaceId: Int, channelName: String)
    }
    
    
    private var disposeBag = DisposeBag()
    private let makeChannelUseCase: MakeChannelUseCaseProtocol
    let type: OperationType
    
    var didSendEventClosure: ( (MakeChannelViewModel.Event) -> Void )?
    
    private let workSpaceId: Int
    
    init(makeChannelUseCase: MakeChannelUseCaseProtocol,
         workSpaceId: Int,
         type: OperationType
    ) {
        self.makeChannelUseCase = makeChannelUseCase
        self.workSpaceId = workSpaceId
        self.type = type
    }
    
    
    struct Input {
        let nameText: ControlProperty<String>
        let descriptionText: ControlProperty<String>
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let initialModel: PublishSubject<OneChannelInfoModel>
        // 만약 "수정하기"로 들어왔으면 여기서 초기 데이터 전달. "생성하기"로 들어오면 아무 이벤트 x
        
        let enabledCompleteButton: BehaviorSubject<Bool>
        let resultMakeChannel: PublishSubject<ResultMakeChannel>
    }
    
    func transform(_ input: Input) -> Output {
        
        let initialModel = PublishSubject<OneChannelInfoModel>()
        let enabledCompleteButton = BehaviorSubject(value: false)
        let resultMakeChannel = PublishSubject<ResultMakeChannel>()
        
        
        // "편집"일 때! 초기 데이터 전달
        if case .edit(let workSpaceId, let channelName) = type {
            print("- 편집하러 들어왔기 때문에 채널 정보 네트워크 콜 쏜다")
            
            
            
            Observable<(Int, String)>.just((workSpaceId, channelName))
                .flatMap { value in
                    self.makeChannelUseCase.oneChannelInfoRequest(ChannelDetailRequestModel(workSpaceId: value.0, channelName: value.1))
                }
                .subscribe(with: self) { owner , response in
                    print("초기 데이터를 위해 채널 정보 콜")
                    print(response)
                }
                .disposed(by: disposeBag)
        }
        
        
        /* --- 테스트용 --- */
        input.nameText
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                print("-- nameText 인풋 : \(value)")
            }
            .disposed(by: disposeBag)
        
        input.descriptionText
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                print("-- description 인풋 : \(value)")
            }
            .disposed(by: disposeBag)
        /* ------------- */
        
        
        // 버튼 활성화
        input.nameText
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                enabledCompleteButton.onNext(!value.isEmpty)
            }
            .disposed(by: disposeBag)
        
        
        // 버튼 클릭
        input.completeButtonClicked
            .withLatestFrom(input.nameText)
            .filter { value in
                if value.count >= 1 && value.count <= 30 {
                    return true
                } else {
                    resultMakeChannel.onNext(.invalid)
                    return false
                }
            }
            .withLatestFrom(input.descriptionText) { v1, v2 in
                return MakeChannelRequestModel(
                    workSpaceId: self.workSpaceId,
                    channelName: v1,
                    channelDescription: v2
                )
            }
            .flatMap {
                self.makeChannelUseCase.makeChannelRequest($0)
            }
            .subscribe(with: self) { owner , response in
                switch response {
                case .success:
                    resultMakeChannel.onNext(.success)  // 의미 없음
                    
                    owner.didSendEventClosure?(.goBackHomeDefault)
                    
                case .failure(let networkError):
                    resultMakeChannel.onNext(.failure(error: networkError))
                }
                print(response)
            }
            .disposed(by: disposeBag)
        
        
        
        
        return Output(
            initialModel: initialModel,
            enabledCompleteButton: enabledCompleteButton,
            resultMakeChannel: resultMakeChannel
        )
    }
}

extension MakeChannelViewModel {
    enum Event {
        case goBackHomeDefault
    }
}
