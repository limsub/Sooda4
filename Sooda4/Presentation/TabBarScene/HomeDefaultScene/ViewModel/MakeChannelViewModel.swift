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
    
    private var disposeBag = DisposeBag()
    
    private let workSpaceId: Int
    
    init(workSpaceId: Int) {
        self.workSpaceId = workSpaceId
    }
    
    struct Input {
        let nameText: ControlProperty<String>
        let descriptionText: ControlProperty<String>
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let enabledCompleteButton: BehaviorSubject<Bool>
        let resultMakeChannel: PublishSubject<ResultMakeChannel>
    }
    
    func transform(_ input: Input) -> Output {
        
        let enabledCompleteButton = BehaviorSubject(value: false)
        let resultMakeChannel = PublishSubject<ResultMakeChannel>()
        
        
        // 
        
        
        
        return Output(
            enabledCompleteButton: enabledCompleteButton,
            resultMakeChannel: resultMakeChannel
        )
    }
}
