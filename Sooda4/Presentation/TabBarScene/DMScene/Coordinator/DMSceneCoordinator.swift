//
//  DMCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit

protocol DMSceneCoordinatorProtocol: Coordinator {
    // view
    func showDMView()
    
    // flow
}


class DMSceneCoordinator: DMSceneCoordinatorProtocol {
    
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
    var type: CoordinatorType = .dm
    
    // 5.
    func start() {
        showDMView()
    }

    
    // 프로토콜 메서드 - view
    func showDMView() {
        print(#function)
        let vc = sample2VC()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension DMSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}

