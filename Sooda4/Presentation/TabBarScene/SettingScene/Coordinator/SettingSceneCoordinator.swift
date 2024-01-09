//
//  SettingCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit

protocol SettingSceneCoordinatorProtocol: Coordinator {
    // view
    func showSettinView()
    
    // flow
}

// 생성 시 반드시 데이터가 필요함. workspace_id: Int
class SettingSceneCoordinator: SettingSceneCoordinatorProtocol {
    
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
    var type: CoordinatorType = .setting
    
    // 5.
    func start() {
        showSettinView()
    }

    
    // 프로토콜 메서드 - view
    func showSettinView() {
        print(#function)
        let vc = sample4VC()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension SettingSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}

