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
    
    
    // 프로토콜 메서드 - view
    func showHomeEmptyView() {
        print(#function)
        
        let homeEmptyVC = HomeEmptyViewController()
        
        homeEmptyVC.k = { [weak self] in
            self?.showMakeWorkSpaceView()
            
        }
        
        navigationController.pushViewController(homeEmptyVC, animated: true)
    }
    
    func showMakeWorkSpaceView() {
        let makeWorkSpaceVM = MakeWorkSpaceViewModel(
            makeWorkSpaceUseCase: MakeWorkSpaceUseCase(
                makeWorkSpaceRepository: MakeWorkSpaceRepository()
            ),
            type: .make
        )
        makeWorkSpaceVM.didSendEventClosure = { [weak self] event in
            switch event {
            case .goHomeDefaultView(let workSpaceId):
                self?.navigationController.dismiss(animated: true)
                self?.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: workSpaceId))
                
            default: break;
            }
        }
        
        let makeWorkSpaceVC = MakeWorkSpaceViewController.create(with: makeWorkSpaceVM)
        
        let nav = UINavigationController(rootViewController: makeWorkSpaceVC)
        
        navigationController.present(nav, animated: true)
    }
}
