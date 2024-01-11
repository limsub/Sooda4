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
        
        // 또 특이한건, workSpaceListVM의 didSendEvent 는 부모 코디인 HomeDefault코디에서 처리한다. VM을 만드는 곳이 여기이기 때문에
        
        let sideMenuNav = SideMenuNavigationController(rootViewController: UIViewController())
        
        sideMenuNav.leftSide = true
        sideMenuNav.presentationStyle = .menuSlideIn
        sideMenuNav.menuWidth = UIScreen.main.bounds.width - 76
        
        let workSpaceListCoordinator = WorkSpaceListCoordinator(sideMenuNav)
        workSpaceListCoordinator.workSpaceId = workSpaceId // * 필수
        workSpaceListCoordinator.finishDelegate = self
        childCoordinators.append(workSpaceListCoordinator)
        workSpaceListCoordinator.start()    // 얘가 필요가 없는거지
        
        navigationController.present(sideMenuNav, animated: true)
    }
}


// MARK: - Child DidFinished
extension HomeDefaultSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
//        navigationController.viewControllers.removeAll()  // 이걸 왜지워 근데??
        navigationController.dismiss(animated: true)
        
        /* 연락이 온다 */
        // 1. 도착지가 HomeDefault코디야. -> 다 dismiss하고 HomeDefaultView 다시 그리라는 뜻
        if let nextFlow = nextFlow as? TabBarCoordinator.ChildCoordinatorType,
           case .homeDefaultScene(let workSpaceId) = nextFlow {
            // 도착지가 나야
            // finish같은거 할 필요 없이.
            // 지금 nav.vcs에 HomeDefaultVC가 있을거야. -> 아마 [0]일거야
            // 걔 지우지 말고, 고대로 뷰모델 네트워크 다시 쏴서 뷰 업데이트 시켜
            
            // 1. HomeDefaultVC 찾아
            navigationController.viewControllers.forEach { vc in
                if let vc = vc as? HomeDefaultViewController {
                    vc.viewModel.workSpaceId = workSpaceId
                    vc.fetchFirstData()
                }
            }
        }
        
        
        
        print(#function)
    }
}

extension HomeDefaultSceneCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case workSpaceList(workSpaceId: Int)
    }
}
