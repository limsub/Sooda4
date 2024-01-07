//
//  HomeEmptySceneCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit

// MARK: - HomeEmptyScene Coordinator Protocol
protocol HomeEmptySceneCoordinatorProtocol: Coordinator {
    
    // view
    func showHomeEmptyView()
    func showMakeWorkSpaceView()
}


// MARK: - HomeEmptyScene Coordinator Class
class HomeEmptySceneCoordinator: HomeEmptySceneCoordinatorProtocol {
    
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
    var type: CoordinatorType = .homeEmptyScene
    
    // 5. - 두 개 필요 (HomeEmptyView)
    func start() {
        showHomeEmptyView()
    }
    
    // 6.
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
        // 1. 자식 코디 지우기 -> 자식 코디 없음
        
        // 2. 부모 코디에게 알리기
        finishDelegate?.coordinatorDidFinish(childCoordinator: self , nextFlow: nextFlow)
    }
    
    // 프로토콜 메서드 - view
    func showHomeEmptyView() {
        print(#function)
        
        let homeEmptyVC = HomeEmptyViewController()
        
        navigationController.pushViewController(homeEmptyVC, animated: true)
    }
    
    func showMakeWorkSpaceView() {
        let makeWorkSpaceVC = MakeWorkSpaceViewController()
        
        navigationController.present(makeWorkSpaceVC, animated: true)
    }
}
