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
    func showHomeDefaultView(_ workSpaceId: Int) // firstView
    
    func showInviteMemberView()
    
    func showMakeChannelView()

    
    // flow
    func showWorkSpaceListFlow(workSpaceId: Int)
    func showExploreChannelFlow()
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
                
            case .presentInviteMemberView:
                self?.showInviteMemberView()
                
            case .presentMakeChannelView:
                self?.showMakeChannelView()
                
            case .goExploreChannelFlow:
                self?.showExploreChannelFlow()
            }
            
        }
        let vc = HomeDefaultViewController.create(with: homeDefaultVM)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showInviteMemberView() {
        print(#function)
        
        // workSpaceId가 nil이면 이게 열리면 안돼
        guard let workSpaceId else { return }
        
        let inviteMemberVM = InviteMemberViewModel(
            workSpaceId: workSpaceId,
            inviteMemberUseCase: InviteWorkSpaceMemberUseCase(
                inviteWorkSpaceMemberRepository: InviteWorkSpaceMemberRepository()
            )
        )
        let inviteMemberVC = InviteMemberViewController.create(with: inviteMemberVM)
        
        inviteMemberVM.didSendEventClosure = { [weak self] event in
            switch event {
            case .goBackHomeDefault:
                // 새롭게 멤버가 초대되었다 -> HomeDefault 뷰를 다시 그릴 필요는 없다.
                // 홈화면에 멤버 관련해서 뭐가 나오는게 없거등
                self?.navigationController.dismiss(animated: true)
            }
        }
        
        let nav = UINavigationController(rootViewController: inviteMemberVC)
        navigationController.present(nav, animated: true)
    }
    
    func showMakeChannelView() {
        print(#function)
    }
    
    
    // 프로토콜 메서드 - flow
    func showWorkSpaceListFlow(workSpaceId: Int) {
        // sidemenunavigationController의 특성상 여기서 vc를 만들어서 넣어줘야 할 것 같다
        // -> nav를 넘기고, 코디 안에서 start로 뷰를 따는게 아니라
        // 아예 여기서부터 첫 vc를 지정해버리고 present로 띄워버림
        // 즉, start가 필요가 없어진다
        

        
        let sideMenuNav = SideMenuNavigationController(rootViewController: UIViewController())
        
        sideMenuNav.leftSide = true
        sideMenuNav.presentationStyle = .menuSlideIn
        sideMenuNav.menuWidth = UIScreen.main.bounds.width - 76
        SideMenuManager.default.leftMenuNavigationController = sideMenuNav
        
        let workSpaceListCoordinator = WorkSpaceListCoordinator(
            workSpaceId,
            nav: sideMenuNav
        )
        workSpaceListCoordinator.finishDelegate = self
        childCoordinators.append(workSpaceListCoordinator)
        workSpaceListCoordinator.start()
        
        
        
        
//        sideMenuNav.navigationBar.clipsToBounds = true
//        sideMenuNav.navigationBar.layer.cornerRadius = 20
//        sideMenuNav.navigationBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        
        // 자.
        // blurView가 좀 화나긴 하는데 일단,
        
        // 띄울 때 isHidden = false
            // -> present할 때
        // 없어질 때 isHiddent = true
            // -> WorkListView가 viewWillDisappear
        
        
//        navigationController.viewControllers.forEach { vc in
//            if let vc = vc as? HomeDefaultViewController {
//                vc.showBlurView(true)
//            }
//        }
        
        

        
        navigationController.present(sideMenuNav, animated: true)
    }
    
    func showExploreChannelFlow() {
        print(#function)
    }
}


// MARK: - Child DidFinished
extension HomeDefaultSceneCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
//        navigationController.viewControllers.removeAll()  // 이걸 해버리면 남아있던 HomeDefault도 날라가. 근데 아마 여기서 얘를 날릴 일은 없을 것 같아. 어차피 얘가 베이스로 깔려있고 위에 present 이것저것 해주고 있어서 ㅇㅇ
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
        
        // 2. 도착지가 HomeEmpty코디야 -> (더 위로 올라가) -> 나중에 분기처리 else 하나로 가능할듯?
        if let nextFlow = nextFlow as? AppCoordinator.ChildCoordinatorType,
           case .homeEmptyScene = nextFlow {
            print("홈디폴트 코디 : finish 실행")
            self.finish(nextFlow)
        }
        
//        print(#function)
    }
}

extension HomeDefaultSceneCoordinator {
    // ex). 워크스페이스리스트에서 워크스페이스 수정하고 난 후
    // - 워크스페이스리스트 뷰가 떠있긴 해야 해
    // - 근데 뒤에 있는 HomeDefault도 수정된 워크스페이스 이름으로 업데이트가 되어야 해.
    // => 즉, dismiss나 차일드코디 지우진 말고, HomeDefault 업데이트만 해줘
    // 일단 지금은 요 한 경우 때문에 구현하는데 나중에 이거랑 비슷한 게 필요하면 여기서 쓰자잉
    func reloadHomeDefault() {
        navigationController.viewControllers.forEach { vc in
            if let vc = vc as? HomeDefaultViewController {
                vc.fetchFirstData()
            }
        }
    }
}

extension HomeDefaultSceneCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case workSpaceList(workSpaceId: Int)
    }
}
