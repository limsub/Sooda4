//
//  ChangeAdminViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import Foundation

class ChangeAdminViewModel {
    
    var didSendEventClosure: ( (ChangeAdminViewModel.Event) -> Void)?
    
    var handleWorkSpaceUseCase: HandleWorkSpaceUseCaseProtocol  // WorkSpaceList 코디가 쓰는 UseCase를 받아올 것
    
    init(handleWorkSpaceUseCase: HandleWorkSpaceUseCaseProtocol) {
        self.handleWorkSpaceUseCase = handleWorkSpaceUseCase
    }
    
    
    
}

extension ChangeAdminViewModel {
    enum Event {
        case goBackWorkSpaceList(changeSuccess: Bool)
    }
}
