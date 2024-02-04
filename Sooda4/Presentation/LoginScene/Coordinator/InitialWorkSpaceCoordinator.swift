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
    func showMakeWorkSpaceView()
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

    
    // 프로토콜 메서드
    func showInitialWorkSpaceView() {
        print(#function)
        
        let initialWorkSpaceVM = InitialWorkSpaceViewModel(
            workSpaceUseCase: WorkSpaceUseCase(
                workSpaceRepository: WorkSpaceRepository()
            )
        )
        let initialWorkSpaceVC = InitialWorkSpaceViewController.create(with: initialWorkSpaceVM)
        
        // 이벤트 받기
        initialWorkSpaceVM.didSendEventClosure = { [weak self] event in
            switch event {
            case .goHomeEmptyView:
                self?.finish(AppCoordinator.ChildCoordinatorType.homeEmptyScene)
                
            case .goHomeDefaultView(let workSpaceId):
                self?.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: workSpaceId))
                break
                
            case .presentMakeWorkSpaceView:
                
                self?.showMakeWorkSpaceView()
                
                break
                
            
            }
        }
        
        navigationController.pushViewController(initialWorkSpaceVC, animated: false)
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
                self?.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: workSpaceId))
                
            default:
                break
            }
            
        }
        
        let makeWorkSpaceVC = MakeWorkSpaceViewController.create(with: makeWorkSpaceVM)
        
        let nav = UINavigationController(rootViewController: makeWorkSpaceVC)
        

        
        
        
        navigationController.present(nav, animated: true)
    }
    
    deinit {
        print("😀😀😀😀😀😀😀  initial workspace Coordinator deinit")
    }
}


// MARK: - No Children
