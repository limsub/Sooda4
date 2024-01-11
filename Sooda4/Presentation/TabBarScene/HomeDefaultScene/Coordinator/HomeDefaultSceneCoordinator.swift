//
//  HomeDefaultCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit
import SideMenu

protocol HomeDefaultSceneCoordinatorProtocol: Coordinator {
    // view
    func showHomeDefaultView(_ workSpaceId: Int)
    
    // flow
    func showWorkSpaceListFlow(workSpaceId: Int)
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
                myWorkSpaceInfoRepository: HomeDefaultWorkSpaceRepository(),
                unreadCountInfoReposiotry: UnreadCountRepository()
            )
        )
        homeDefaultVM.didSendEventClosure = { [weak self] event in
            
            switch event {
            case .presentWorkSpaceListView(let workSpaceId):
                self?.showWorkSpaceListFlow(workSpaceId: workSpaceId)
            }
            
        }
        let vc = HomeDefaultViewController.create(with: homeDefaultVM)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    // 프로토콜 메서드 - flow
    func showWorkSpaceListFlow(workSpaceId: Int) {
        // sidemenunavigationController의 특성상 여기서 vc를 만들어서 넣어줘야 할 것 같다
        // -> nav를 넘기고, 코디 안에서 start로 뷰를 따는게 아니라
        // 아예 여기서부터 첫 vc를 지정해버리고 present로 띄워버림
        // 즉, start가 필요가 없어진다
        
        let workSpaceListVM = WorkSpaceListViewModel(
            workSpaceUseCase: WorkSpaceUseCase(
                workSpaceRepository: WorkSpaceRepository()
            ),
            selectedWorkSpaceId: workSpaceId
        )
        let vc = WorkSpaceListViewController.create(with: workSpaceListVM)
        let sideMenuNav = SideMenuNavigationController(rootViewController: vc)
        sideMenuNav.leftSide = true
        sideMenuNav.presentationStyle = .menuSlideIn
        sideMenuNav.menuWidth = UIScreen.main.bounds.width - 76
        
        let workSpaceListCoordinator = WorkSpaceListCoordinator(sideMenuNav)
        workSpaceListCoordinator.finishDelegate = self
        childCoordinators.append(workSpaceListCoordinator)
//        workSpaceListCoordinator.start()    // 얘가 필요가 없는거지
        
        navigationController.present(sideMenuNav, animated: true)
    }
}

extension HomeDefaultSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function)
    }
}

extension HomeDefaultSceneCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case workSpaceList(workSpaceId: Int)
    }
}
