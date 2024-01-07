//
//  InitialWorkSpaceCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

// MARK: - InitialWorkSpace Coordinator Protocol
protocol InitialWorkSpaceCoordinatorProtocol: Coordinator {
    // view
    func showInitialWorkSpaceView()
}


// MARK: - InitialWorkSpace Coordinator Class
class InitialWorkSpaceCoordinator: InitialWorkSpaceCoordinatorProtocol {
    
    
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
    var type: CoordinatorType = .initialWorkSpace
    
    // 5.
    func start() {
        showInitialWorkSpaceView()
    }
    
    // 6.
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
        // 1. 자식 코디 없음
        
        // 2. 부모 코디에게 알림
        finishDelegate?.coordinatorDidFinish(
            childCoordinator: self ,
            nextFlow: nextFlow
        )
    }
    
    // 프로토콜 메서드
    func showInitialWorkSpaceView() {
        print(#function)
        
        let initialWorkSpaceVM = InitialWorkSpaceViewModel()
        let initialWorkSpaceVC = InitialWorkSpaceViewController.create(with: initialWorkSpaceVM)
        
        // 이벤트 받기
        initialWorkSpaceVM.didSendEventClosure = { [weak self] event in
            switch event {
            case .goHomeEmptyView:
                self?.finish(AppCoordinator.ChildCoordinatorType.homeEmptyScene(.homeEmptyView))
                
            case .goMakeWorkSpaceView:
                self?.finish(AppCoordinator.ChildCoordinatorType.homeEmptyScene(.makeWorkSpace))
                
            }
        }
        
        navigationController.pushViewController(initialWorkSpaceVC, animated: false)
    }
}


// MARK: - No Children
