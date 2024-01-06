//
//  AppCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

// Every app should have one main coordinator (start point of all flow) => AppCoordinator

// MARK: - App Coordinator Protocol
protocol AppCoordinatorProtocol: Coordinator {
    // view
    
    // flow
    func showSplashFlow()
    func showLoginFlow()
    func showHomeEmptyFlow()
    func tabBarFlow()
}

// MARK: - App Coordinator Class
class AppCoordinator: AppCoordinatorProtocol {
    
    
    
    
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate? = nil   // AppCoordinator : 부모 코디 x
    
    // 2.
    var navigationController: UINavigationController
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .app
    
    // 5.
    func start() {
        showSplashFlow()
    }
    
    // 6.
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
        // 1. 자식 코디 다 지우기
        childCoordinators.removeAll()
        
        /* 궁금한 점. navigationController에 쌓인 것들이나, present로 띄운 애들을 제거하는 과정은 필요하지 않은가?*/
        
        // 2. 부모 코디에게 알리기
        finishDelegate?.coordinatorDidFinish(
            childCoordinator: self,
            nextFlow: nextFlow   // 이게 실행될 일 없음
        )
    }
    
    
    // 프로토콜 메서드
    func showSplashFlow() {
        print(#function)
        
        let splashCoordinator = SplashCoordinator(navigationController)
        splashCoordinator.finishDelegate = self
        childCoordinators.append(splashCoordinator)
        splashCoordinator.start()
    }
    
    func showLoginFlow() {
        print(#function)
    }
    
    func showHomeEmptyFlow() {
        print(#function)
    }
    
    func tabBarFlow() {
        print(#function)
    }
    
    deinit {
        print("앱코디 디이닛")
    }
}

// MARK: - Child Didfinished
extension AppCoordinator: CoordinatorFinishDelegate {
    
    // CoordinatorFinishDelegate
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
        print("--- 이게 실행되면 문제가 있는 상황 ---")
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
    }
}

// MARK: - Child Coordinator 타입
extension AppCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case splah, loginScene, TabBarScene, homeEmptyScene
    }
}
