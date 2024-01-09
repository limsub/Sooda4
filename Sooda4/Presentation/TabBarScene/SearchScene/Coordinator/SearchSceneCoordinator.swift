//
//  SearchCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit

protocol SearchSceneCoordinatorProtocol: Coordinator {
    // view
    func showSearchView()
    
    // flow
}

// 생성 시 반드시 데이터가 필요함. workspace_id: Int
class SearchSceneCoordinator: SearchSceneCoordinatorProtocol {
    
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
    var type: CoordinatorType = .search
    
    // 5.
    func start() {
        showSearchView()
    }
    
    
    // 프로토콜 메서드 - view
    func showSearchView() {
        print(#function)
        let vc = sample3VC()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension SearchSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}

