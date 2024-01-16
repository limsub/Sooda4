//
//  TabBarCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    
}


class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol {
    
    
    var tabBarController: UITabBarController
    
    // 1.
    var finishDelegate: CoordinatorFinishDelegate?
    
    // 2.
    var navigationController: UINavigationController
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .tabBarScene
    
    // HomeDefault를 실행하기 위해서는 workSpaceID를 받아야 함
    var workSpaceId: Int?
    
    func start() {
        guard let workSpaceId else { return }
        
        
        let pages: [ChildCoordinatorType] = [
            .homeDefaultScene(workSpaceId: workSpaceId),
            .dmScene,
            .searchScene,
            .settingScene
        ]
        
        let controllers: [UINavigationController] = pages.map {
            getFlow($0).navigationController
        }
        
        prepareTabBarController(with: controllers)
    }

    
}

extension TabBarCoordinator {
    
    private func getFlow(_ page: ChildCoordinatorType) -> Coordinator {
        
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: page.title,
            image: UIImage(named: page.unselectedImage),
//            selectedImage: UIImage(systemName: "pencil")
            selectedImage: UIImage(named: page.selectedImage)?.withTintColor(.black)
        )
        
        switch page {
        case .homeDefaultScene(let workSpaceId):
            let homeDefaultSceneCoordinator = HomeDefaultSceneCoordinator(nav)
            homeDefaultSceneCoordinator.workSpaceId = workSpaceId
            childCoordinators.append(homeDefaultSceneCoordinator)
            homeDefaultSceneCoordinator.finishDelegate = self
            homeDefaultSceneCoordinator.start()
            
            return homeDefaultSceneCoordinator
            
        case .dmScene:
            let dmSceneCoordinator = DMSceneCoordinator(nav)
            childCoordinators.append(dmSceneCoordinator)
            dmSceneCoordinator.finishDelegate = self
            dmSceneCoordinator.start()
            
            return dmSceneCoordinator
            
        case .searchScene:
            let searchSceneCoordinator = SearchSceneCoordinator(nav)
            childCoordinators.append(searchSceneCoordinator)
            searchSceneCoordinator.finishDelegate = self
            searchSceneCoordinator.start()
            
            return searchSceneCoordinator
            
        case .settingScene:
            let settingSceneCoordinator = SettingSceneCoordinator(nav)
            childCoordinators.append(settingSceneCoordinator)
            settingSceneCoordinator.finishDelegate = self
            settingSceneCoordinator.start()
            
            return settingSceneCoordinator
            
        }
        
    }
    
    
    private func prepareTabBarController(with navControllers: [UINavigationController]) {
        
        tabBarController.tabBar.backgroundColor = .white
        
        tabBarController.delegate = self
        
        tabBarController.setViewControllers(navControllers, animated: true)
        
        // 첫 번째 화면
        tabBarController.selectedIndex = 0  // 이게 꼭 필요할까? 싶음
        
        tabBarController.tabBarItem.isEnabled = true
        tabBarController.tabBar.tintColor = UIColor.appColor(.brand_black)
        tabBarController.tabBar.unselectedItemTintColor = UIColor.appColor(.brand_inactive)
        
        
        // 현재 코디네이터의 네비게이션 컨트롤러의 뷰로 잡아준다
        navigationController.viewControllers = [tabBarController]
        navigationController.setNavigationBarHidden(true , animated: false) // 얘 네비게이션은 굳이 보일 필요가 없을 것 같음
    }
    

}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()
        
        
        
        // 나중에 분기처리 깔끔하게 정리하기
        
        
        // 1. workspacelist에서 워크스페이스 싹 다 제거해서 더 이상 남은 워크스페이스 없는 경우. (nextFlow = 앱코디.차일드.홈엠티)
        if let nextFlow = nextFlow as? AppCoordinator.ChildCoordinatorType,
           case .homeEmptyScene = nextFlow {
            print("탭바 코디 : finish 실행")
            self.finish(nextFlow)
        }
        
        // 2. 로그아웃해서 LoginScene으로 돌아가는 경우
        if let nextFlow = nextFlow as? AppCoordinator.ChildCoordinatorType,
           case .loginScene = nextFlow {
            self.finish(nextFlow)
        }
        
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    
}

extension TabBarCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        
        case homeDefaultScene(workSpaceId: Int)
        case dmScene, searchScene, settingScene
        
        
        
        /* === 탭바 커스텀용 === */
        var title: String {
            switch self {
            case .homeDefaultScene:
                return "홈"
            case .dmScene:
                return "DM"
            case .searchScene:
                return "검색"
            case .settingScene:
                return "설정"
            }
        }
        
        var unselectedImage: String {
            switch self {
            case .homeDefaultScene:
                return "tabItem_home"
            case .dmScene:
                return "tabItem_message"
            case .searchScene:
                return "tabItem_profile"
            case .settingScene:
                return "tabItem_setting"
            }
        }
        
        var selectedImage: String {
            return unselectedImage + "_active"
        }
    }
}
