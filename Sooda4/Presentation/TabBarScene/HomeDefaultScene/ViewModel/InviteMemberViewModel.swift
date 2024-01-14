//
//  InviteViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class InviteMemberViewModel: BaseViewModelType {
    
    var didSendEventClosure: ( (InviteMemberViewModel.Event) -> Void )?
    
    struct Input {
        let emailText: ControlProperty<String>
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let result: PublishSubject<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let result = PublishSubject<Bool>()
        
        return Output(
            result: result
        )
    }
}

extension InviteMemberViewModel {
    enum Event {
        case goBackHomeDefault
    }
}
