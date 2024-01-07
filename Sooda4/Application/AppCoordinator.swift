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
    func showTabBarFlow()
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
        
        let loginCoordinator = LoginSceneCoordinator(navigationController)
        loginCoordinator.finishDelegate = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func showHomeEmptyFlow() {
        print(#function)
        
        let homeEmptyCoordinator = HomeEmptySceneCoordinator(navigationController)
        homeEmptyCoordinator.finishDelegate = self
        childCoordinators.append(homeEmptyCoordinator)
        homeEmptyCoordinator.start()
    }
    
    func showTabBarFlow() {
        print(#function)
    }
    
    deinit {
        print("앱코디 디이닛")
    }
}

// MARK: - Child Didfinished
extension AppCoordinator: CoordinatorFinishDelegate {
    
    // CoordinatorFinishDelegate
    func coordinatorDidFinish(
        childCoordinator: Coordinator,
        nextFlow: ChildCoordinatorTypeProtocol?
    ) {
        print(#function, Swift.type(of: self))
        
        print("매개변수로 받은 nextFlow : ", nextFlow)
        
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()
        // present된 애들도 없애줘야 하지 않을까..? navigationController.dismiss??
        
        if let nextFlow = nextFlow as? ChildCoordinatorType {
            switch nextFlow {
            case .splash:
                print("여기로 가자고 하는 애는 없어야 해...")
            case .loginScene:
                // TODO: - show LoginFlow
                self.showLoginFlow()
                break;
            case .tabBarScene:
                // TODO: - show TabBarFlow
                self.showTabBarFlow()
                break;
            case .homeEmptyScene:
                // TODO: - show HomeEmptyFlow
                self.showHomeEmptyFlow()
                
                
                break;
            }
        }
    }
}

// MARK: - Child Coordinator 타입
extension AppCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case splash, loginScene, tabBarScene
        
        case homeEmptyScene
        
    }
}
