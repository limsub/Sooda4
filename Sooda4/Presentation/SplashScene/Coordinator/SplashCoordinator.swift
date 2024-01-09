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
        
        let splashVM = SplashViewModel()
        let splashVC = SplashViewController.create(with: splashVM)
        
        splashVM.didSendEventClosure = { [weak self] event in
            // 응답 받으면 splash코디는 끝나는 거고, -> finish
            // 형제 코디 중 하나를 실행해달라고 부모 코디에게 전달해야 함 -> (next: )
            switch event {
            case .goLoginScene:
                self?.finish(AppCoordinator.ChildCoordinatorType.loginScene)
                break;
                
            case .goTabBarScene:
                self?.finish(AppCoordinator.ChildCoordinatorType.tabBarScene)
                break;
            
            case .goHomeEmptyScene:
                self?.finish(AppCoordinator.ChildCoordinatorType.homeEmptyScene)
                break;
            }
        }
        
        navigationController.pushViewController(splashVC, animated: true)
    }
    
    
    deinit {
        print("splash Coordinator deinit")
    }
}

// MARK: - Child Didfinished
extension SplashCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
        
        print("--- 자식 코디가 없기 때문에 이게 실행되면 안된다", Swift.type(of: self))
    }
}
