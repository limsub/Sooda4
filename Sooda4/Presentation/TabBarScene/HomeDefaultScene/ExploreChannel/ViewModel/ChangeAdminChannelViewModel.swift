//
//  ChangeAdminChannelViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/17/24.
//

import Foundation
import RxSwift
import RxCocoa

class ChangeAdminChannelViewModel: BaseViewModelType {
    
    var didSendEventClosure: ( (ChangeAdminViewModel.Event) -> Void )?
        
    private let workSpaceId: Int
    private let channelName: String
    
    private var handleChannelUseCase: HandleChannelUseCaseProtocol

    var items: [WorkSpaceUserInfo] = []
    
    init(workSpaceId: Int, channelName: String, handleChannelUseCase: HandleChannelUseCaseProtocol, items: [WorkSpaceUserInfo]) {
        self.workSpaceId = workSpaceId
        self.channelName = channelName
        self.handleChannelUseCase = handleChannelUseCase
        self.items = items
    }
    
    struct Input {
        let a: String
    }
    
    struct Output {
        let b: String
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output(b: "hi")
    }
}

// Event
extension ChangeAdminChannelViewModel {
    enum Event {
        case goBackChannelSetting
    }
}
