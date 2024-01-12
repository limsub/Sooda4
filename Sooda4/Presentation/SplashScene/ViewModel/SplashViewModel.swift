//
//  File.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation

class SplashViewModel {
    
    // Coordinator에게 어떤 화면으로 전환할지 요청 
    var didSendEventClosure: ( (SplashViewModel.Event) -> Void)?
    
    // 1. 타이머 시작
    // 2. 네트워크 콜
    // 3 - 1. 1초 후, 응답값 왔으면 화면 전환 go
    // 3 - 2. 1초 후, 응답값 없으면, 응답 올 때까지 기다리고 go
    // 4. 10초 지났는데도 응답값 없으면 go Login Scene
    
    
    // (임시) 일단 그냥 1초 지나면 화면전환
    func transitionNextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            
            self?.didSendEventClosure?(.goLoginScene)
//            self?.didSendEventClosure?(.goHomeDefault(workSpaceId: 18))
        }
    }
}

// MARK: - SplashView Event
extension SplashViewModel {
    enum Event {
        case goLoginScene
        case goHomeDefault(workSpaceId: Int)  // TabBar
        case goHomeEmptyScene
    }
}
