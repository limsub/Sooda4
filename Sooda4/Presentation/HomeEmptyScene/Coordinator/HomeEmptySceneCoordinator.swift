//
//  HomeEmptySceneCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit
import SideMenu

// MARK: - HomeEmptyScene Coordinator Protocol
protocol HomeEmptySceneCoordinatorProtocol: Coordinator {
    
    // view
    func showHomeEmptyView()
    func showMakeWorkSpaceView()
    
    func showWorkSpaceFlow()
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
    
    // 5. - 두 개 필요 (HomeEmptyView) -> ??
    func start() {
        showHomeEmptyView()
    }
    
    
    // 프로토콜 메서드 - view
    func showHomeEmptyView() {
        print(#function)
        
        let homeEmptyVM = HomeEmptyViewModel()
        homeEmptyVM.didSendEventClosure = { [weak self] event in
        
            switch event {
            case .showMakeWorkSpace:
                self?.showMakeWorkSpaceView()
                
            case .showWorkSpaceList:
                print("0000000")
                self?.showWorkSpaceFlow()
            }
        }
        
    
        let homeEmptyVC = HomeEmptyViewController.create(with: homeEmptyVM)
        navigationController.pushViewController(homeEmptyVC, animated: false)
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
    
    func showWorkSpaceFlow() {
        print(#function)
        
        let sideMenuNav = SideMenuNavigationController(rootViewController: UIViewController())
        
        sideMenuNav.leftSide = true
        sideMenuNav.presentationStyle = .menuSlideIn
        sideMenuNav.menuWidth = UIScreen.main.bounds.width - 76
        SideMenuManager.default.leftMenuNavigationController = sideMenuNav
        
        let workSpaceListCoordinator = WorkSpaceListCoordinator(
            nil,
            nav: sideMenuNav
        )
        workSpaceListCoordinator.finishDelegate = self
        childCoordinators.append(workSpaceListCoordinator)
        workSpaceListCoordinator.start()
        
        navigationController.present(sideMenuNav, animated: true)
    }
}


// MARK: - Child DidFinished
extension HomeEmptySceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
        navigationController.viewControllers.removeAll()
        navigationController.dismiss(animated: true)
        
        
        // Child는 WorkSpaceList밖에 없음
        // 거기서 할 건 새로운 워크스페이스 만드는거밖에 없고
        // 그럼 일단 거기서 끝났으면 앱코디.탭바코디.홈디폴트 가 nextFlow일거야
        // 얘 입장에선 그럼 부모로 넘겨주고 얘도 죽을 수밖에 없어
        finish(nextFlow)
        
        
    }
}
