//
//  SplashCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

// MARK: - Splash Coordinator Protocol
protocol SplashCoordinatorProtocol: Coordinator {
    // view
    func showSplashView()
    
    // flow
    func showLoginFlow()
    func showTabBarFlow()
}

// MARK: - Splash Coordinator Class
class SplashCoordinator: SplashCoordinatorProtocol {
    
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    // 2.
    var navigationController: UINavigationController
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .splash
    
    // 5.
    func start() {
        showSplashView()
    }
    
    // 프로토콜 메서드
    func showSplashView() {
        print(#function)
        
        // TODO: splashVC, splashVM
    }
    
    func showLoginFlow() {
        print(#function)
        
        // TODO: loginCoordinator
    }
    
    func showTabBarFlow() {
        // TODO: tabBarCoordinator
    }
    
    
    deinit {
        print("splash Coordinator deinit")
    }
}

// MARK: - Child Didfinished
extension SplashCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
        print(#function, Swift.type(of: self))
        
        // TODO: - 로그인 플로우가 끝났으면 탭바 플로우로 돌려주기. 탭바 플로우는 끝나면 뭐 없다.
        
    }
}
