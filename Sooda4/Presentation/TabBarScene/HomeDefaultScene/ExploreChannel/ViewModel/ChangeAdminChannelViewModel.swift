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
    
//    var didSendEventClosure: ( (ChangeAdminViewModel.Event) -> Void )?
//    
//    
//    let workSpaceId: Int
//    let channelName: String
//    
    var items: [WorkSpaceUserInfo] = []
    
    
    
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
