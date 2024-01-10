//
//  HomeDefaultCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit

protocol HomeDefaultSceneCoordinatorProtocol: Coordinator {
    // view
    func showHomeDefaultView(_ workSpaceId: Int)
    
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
        guard let workSpaceId else { print("워크스페이스 아이디 안넣음!!"); return; }
        showHomeDefaultView(workSpaceId)
    }

    
    // 프로토콜 메서드 - view
    func showHomeDefaultView(_ workSpaceId: Int) {
        let homeDefaultVM = HomeDefaultViewModel(
            workSpaceId: workSpaceId,
            homeDefaultWorkSpaceUseCase: HomeDefaultWorkSpaceUseCase(
                myWorkSpaceInfoRepository: HomeDefaultWorkSpaceRepository()
            )
        )
        let vc = HomeDefaultViewController.create(with: homeDefaultVM)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension HomeDefaultSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}
