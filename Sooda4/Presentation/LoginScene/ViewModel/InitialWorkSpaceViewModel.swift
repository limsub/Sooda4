//
//  InitialWorkSpaceViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation

class InitialWorkSpaceViewModel {
    
    
    var didSendEventClosure: ( (InitialWorkSpaceViewModel.Event) -> Void)?
    
    
}


extension InitialWorkSpaceViewModel {
    enum Event {
        case goHomeEmptyView
        case goMakeWorkSpaceView
    }
}
