//
//  AppCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

// Every app should have one main coordinator (start point of all flow) => AppCoordinator

// MARK: - App Coordinator Protocol
protocol AppCoordinatorProtocol: Coordinator {
    // view
    
    // flow
    func showSplashFlow()
    func showLoginFlow()
    func showHomeEmptyFlow()
    func showTabBarFlow(workSpaceId: Int)
    
    
    // direct show view (Push Notification click)
    func showDirectChannelChattingView(workSpaceId: Int, channelId: Int, channelName: String?)
}

// MARK: - App Coordinator Class
class AppCoordinator: AppCoordinatorProtocol {
    
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate? = nil   // AppCoordinator : 부모 코디 x
    
    // 2.
    var navigationController: UINavigationController
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .app
    
    // 5.
    func start() {
        showSplashFlow()
//        showMyProfileView()
    }
    
    
    // 프로토콜 메서드
    func showSplashFlow() {
        print(#function)
        
        let splashCoordinator = SplashCoordinator(navigationController)
        splashCoordinator.finishDelegate = self
        childCoordinators.append(splashCoordinator)
        splashCoordinator.start()
    }
    
    func showLoginFlow() {
        print(#function)
        
        let loginCoordinator = LoginSceneCoordinator(navigationController)
        loginCoordinator.finishDelegate = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func showHomeEmptyFlow() {
        print(#function)
        
        
        let homeEmptyCoordinator = HomeEmptySceneCoordinator(navigationController)
        homeEmptyCoordinator.finishDelegate = self
        childCoordinators.append(homeEmptyCoordinator)
        homeEmptyCoordinator.start()
    }
    
    func showTabBarFlow(workSpaceId: Int) {
        print(#function)
        
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.workSpaceId = workSpaceId
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func showDirectChannelChattingView(
        workSpaceId: Int,
        channelId: Int,
        channelName: String?
    ) {
        print(#function)
        
        /*
        1. AppCoordinator child removeAll

        2. AppCoordinator showTabbarFlow(workspaceId: Int)

        3. TabbarCoordinator prepareTabBarController(selectedItem = 0)

        // channel
        4 - 1. HomeDefaultCoordinator showChannelChatting

        //dm
        4 - 2. HomeDefaultCoordinator showDMChatting
*/
        
        // 1. child coordinator removeAll
        childCoordinators.removeAll()
        navigationController.viewControllers.removeAll()
        
        // 2. show tabBar flow
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.workSpaceId = workSpaceId
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
        // (-> homeDefaultCoordinator start)
        
        
        // 3. HomeDefaultCoordinator show ChannelChatting
        for i in 0...3 {
            if let homeDefaultCoordinator =  tabBarCoordinator.childCoordinators[i] as? HomeDefaultSceneCoordinatorProtocol {
                
                homeDefaultCoordinator.showChannelChattingView(
                    workSpaceId: workSpaceId,
                    channelId: channelId,
                    channelName: channelName
                )
            }
        }
        
        
    }
    
    deinit {
        print("앱코디 디이닛")
    }
}

// MARK: - Child Didfinished
extension AppCoordinator: CoordinatorFinishDelegate {
    
    // CoordinatorFinishDelegate
    func coordinatorDidFinish(
        childCoordinator: Coordinator,
        nextFlow: ChildCoordinatorTypeProtocol?
    ) {
        print("😀😀😀😀😀 필터 넣기 전 Child코디 : \(childCoordinators)")
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        print("😀😀😀😀😀 필터 넣기 후 Child코디 : \(childCoordinators)")
        navigationController.viewControllers.removeAll()
        navigationController.setNavigationBarHidden(false , animated: false)
        
        // present된 애들도 없애줘야 하지 않을까..? navigationController.dismiss??
        // -> 일단 이 navController에서 present된 애들은 없어. LoginScene에서는 dismiss 해주고 있다.
        
        
        /* App코디에게 연락이 온다.
         1. Child
         2. Child의 Child
         3. 부모 타고 가야 하는 코디 -> 없음
         */
        
        print("앱코디 : didfinish 받음")
        
        // 1 .Child
        if let nextFlow = nextFlow as? ChildCoordinatorType {
            switch nextFlow {
            case .splash:
                print("여기로 가자고 하는 애는 없어야 해...")
                
            case .loginScene:
                self.showLoginFlow()
                
            case .tabBarScene:
                print("이것도 실행되면 안된다. 탭바 코디 중 정확히 어디로 갈지 전달받아야 한다")
                
            case .homeEmptyScene:
                print("앱코디 : show homeempty flow")
                self.showHomeEmptyFlow()
                
            }
        }
        
        // 2. Child의 Child
        // - 이렇게 갈 수 있는건 일단 TabBar코디 쪽밖에 없음
        if let nextFlow = nextFlow as? TabBarCoordinator.ChildCoordinatorType {
            switch nextFlow {
            case .homeDefaultScene(let workSpaceId):
                showTabBarFlow(workSpaceId: workSpaceId)
            case .dmScene:
                break;
            case .searchScene:
                break;
            case .settingScene:
                break;
            }
        }
    }
}

// MARK: - Child Coordinator 타입
extension AppCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case splash
        case loginScene
        case tabBarScene
        case homeEmptyScene
    }
}
