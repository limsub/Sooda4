//
//  LoginSceneCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

// MARK: - LoginScene Coordinator Protocol
protocol LoginSceneCoordinatorProtocol: Coordinator {
    // view
    func showOnboardingView()
    
    // flow
    func showSelectAuthFlow()   // present
    func showInitialWorkSpaceFlow()

}


// MARK: - LoginScene Coordinator Class
class LoginSceneCoordinator: LoginSceneCoordinatorProtocol {
    
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
    var type: CoordinatorType = .loginScene
    
    // 5.
    func start() {
        showOnboardingView()
//        showInitialWorkSpaceFlow()
    }
    
    // 6.
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
        // 1. 자식 코디 다 지우기
        childCoordinators.removeAll()
        
        // 2. 부모 코디에게 알리기
            // -> HomeEmpty, TabBar 중 어디로 갈지 알린다
        finishDelegate?.coordinatorDidFinish(
            childCoordinator: self,
            nextFlow: nextFlow
        )
    }
    
    // 프로토콜 메서드 - view
    func showOnboardingView() {
        print(#function)
        
        let onboardingVM = OnboardingViewModel()
        let onboardingVC = OnboardingViewController.create(with: onboardingVM)
        
        // 화면 전환을 위한 Event 받기
        onboardingVM.didSendEventClosure = { [weak self] event in
            
            // 여긴 무조건 showSelectAuthFlow. 문제는 present
            switch event {
            case .presentSelectAuthView:
                self?.showSelectAuthFlow()
            }
        }
        // 전환 - fade 효과
        setUpViewFadeEffect()
        navigationController.pushViewController(onboardingVC, animated: false)
    }
    
    // 프로토콜 메서드 - flow
    func showSelectAuthFlow() {
        // TODO: selectAuthFlow 시작. present로 진행. 별도의 navigationController 주입
        print(#function)
        
        // 새로 만드는 nav는 어차피 여기서 관리하지는 않을거고, 새로운 코디에서 관리할 예정이기 때문에 현재 코디에서 따로 변수로 가지고 있을 필요는 없다
        // 단지, 현재 코디와 다른 nav를 가질 수 있도록 주입해주는 것 뿐임
        let nav = UINavigationController()
        let selectAuthCoordinator = SelectAuthCoordinator(nav)
        selectAuthCoordinator.finishDelegate = self
        childCoordinators.append(selectAuthCoordinator)
        selectAuthCoordinator.start()   // 이걸 실행하면 naviagation push로 화면이 들어옴
        
        // 그 화면을 present로 띄워준다!
        navigationController.present(selectAuthCoordinator.navigationController, animated: true)
    }
    
    func showInitialWorkSpaceFlow() {
        // 갈아끼기
        let initialWorkSpaceCoordinator = InitialWorkSpaceCoordinator(navigationController)
        initialWorkSpaceCoordinator.finishDelegate = self
        childCoordinators.append(initialWorkSpaceCoordinator)
        initialWorkSpaceCoordinator.start()
        
    }
    
}

// MARK: - Child DidFinished
extension LoginSceneCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function, Swift.type(of: self))
        
        print("-- 자식 코디가 끝났다는 소식 들었으니까 처리해주자 - 받는 입장")
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()
        navigationController.dismiss(animated: true)
        
        /* == 여긴 나중에 코드 좀 합칠 수 있을 것 같음. 일단 직관적으로 이해하기 위해 요렇게 해두자*/
        /* == 어차피 값전달 할 건 없는 것 같으니까 nextFlow가 누구 Child코디인지 분기 처리하고 요러쿵 저러쿵 하면 될 듯? */
        switch childCoordinator.type {
        case .selectAuth:
            
            // 1. SelectAuth에서 소식이 들려옴 (SignUpView)
            // - SignUp 성공했으니까 나 죽고 InitialWorkSpace코디 실행시켜줘
            // : SignUp dismiss, SelectAuth dismiss -> 한 번에 되나?
            // -> 위에 navigationController.dismiss 하나 쓰니까 된다.
            if let nextFlow = nextFlow as? ChildCoordinatorType,
               nextFlow == .initialWorkSpace {
                
                self.showInitialWorkSpaceFlow()
            }
            
            
            // 2. SelectAuth에서 또 소식이 들려옴 (EmailLoginView)
            // - 로그인 성공했는데 얘 워크스페이스 없으니까 HomeEmptyScenc코디에 HomeEmptyView 띄워라
            
            
            // 3. SelectAuth에서 또 소식 들려옴 (EmailLoginView)
            // - 로그인 성공했는데 얘 워크스페이스 있으니까 TabBar코디 띄워라
            
            
            // 4. SelectAuth에서 소식 (SelectAuthView)
            // - 소셜 로그인 성공했는데 얘 워크스페이스 없으니까 HomeEmptyScenc코디에 HomeEmptyView 띄워라
            
            // 5. SelectAuth에서 소식 (SelectAuthView)
            // - 소셜 로그인 성공했는데 얘 워크스페이스 있으니까 TabBar코디 띄워라
            
            
            break
            
        case .initialWorkSpace:
            
            
            if let nextFlow = nextFlow as? AppCoordinator.ChildCoordinatorType {
                
                // 6. initialWorkSpace의 initalWorkSpaceView에서 x 버튼
                // -> HomeEmpty 코디의 HomeEmptyView
                if case .homeEmptyScene = nextFlow {
                    finish(AppCoordinator.ChildCoordinatorType.homeEmptyScene)
                }
                
                
                // 7. initialWorkSpace의 makeworkSpaceView에서 완성
                // -> 탭바코디
                if case .tabBarScene = nextFlow {
                    finish(AppCoordinator.ChildCoordinatorType.tabBarScene)
                }
            }
            break
            
        default:
            break
        }
        
        
        
        
    }
}

// MARK: - Child Coordinator Type
extension LoginSceneCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case selectAuth, initialWorkSpace
    }
}

extension LoginSceneCoordinator {
    func setUpViewFadeEffect() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        navigationController.view.window?.layer.add(transition, forKey: kCATransition)
    }
}
