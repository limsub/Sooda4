//
//  SelectAuthViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation

class SelectAuthViewModel {
    
    // Coordinator에게 어떤 화면으로 전환할지 요청
    var didSendEventClosure: ( (SelectAuthViewModel.Event) -> Void)?
    
}


extension SelectAuthViewModel {
    enum Event {
        case presentSignUpView
    }
}
