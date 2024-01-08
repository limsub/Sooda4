//
//  HomeDefaultCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit

protocol HomeDefaultSceneCoordinatorProtocol: Coordinator {
    // view
    func showHomeDefaultView()
    
    // flow
}

// 생성 시 반드시 데이터가 필요함. workspace_id: Int
class HomeDefaultSceneCoordinator: HomeDefaultSceneCoordinatorProtocol {
    
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
    var type: CoordinatorType = .homeDefault
    
    
    // 5.
    var workSpaceId: Int?
    func start() {
        guard let workSpaceId else { return }
        showHomeDefaultView()
    }
    
    // 6
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
        // 1.
        childCoordinators.removeAll()
        
        // 2.
        finishDelegate?.coordinatorDidFinish(
            childCoordinator: self,
            nextFlow: nextFlow
        )
    }
    
    // 프로토콜 메서드 - view
    func showHomeDefaultView() {
        let vc = HomeDefaultViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension HomeDefaultSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}
