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
    
    // 6.
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
        // 1. 자식 코디 다 지우기
        childCoordinators.removeAll()
        
        // 2. 부모 코디에게 알리기
        finishDelegate?.coordinatorDidFinish(
            childCoordinator: self ,
            nextFlow: nextFlow
        )
    }
    
    // 프로토콜 메서드
    func showSplashView() {
        print(#function)
        
        
        let splashVM = SplashViewModel()
        let splashVC = SplashViewController.create(with: splashVM)
        
        // TODO: VM - DidSendEventClosure
        splashVM.didSendEventClosure = { [weak self] event in
            
            // didfinish로 부모 코디(AppCoordi)에게 나 끝났다고 알리고, 매개변수로 다음 어디 코디로 전환할지 알려줘
            print("보내는 입장")
            
            switch event {
            case .goLoginScene:
//                self?.showLoginFlow()
                break;
                
            case .goTabBarScene:
                break;
            
            case .goHomeEmptyScene:
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
