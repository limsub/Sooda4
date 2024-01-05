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
    func showSplashFlow()
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
    
    
    // 프로토콜 메서드
    func showSplashFlow() {
        print(#function)
        
        // TODO: splash Coordinator
    }
    
    deinit {
        print("앱코디 디이닛")
    }
}

// MARK: - Child Didfinished
extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print(#function)
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        
        // 아마 이게 실행될 일은 없을듯
        switch childCoordinator.type {
        case .splash:
            print("이게 실행되면 문제가 있는거여")
        default:
            break
        }
    }
    
}
