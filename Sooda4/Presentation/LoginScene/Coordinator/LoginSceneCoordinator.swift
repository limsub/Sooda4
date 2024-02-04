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
    
    deinit {
        print("😀😀😀😀😀😀😀  loginscene Coordinator deinit")
    }
    
}

// MARK: - Child DidFinished
extension LoginSceneCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
    
        print("로그인씬코디 : 자식 코디가 끝났다는 소식 들었다. nextFlow : \(nextFlow)")
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()  // 이걸 왜지우지?????!?!?!?
        // -> 사실상 자식 코디로 연결된 애는 딱 하나이고, 걔가 죽었다는 뜻은 걔한테 연결된 뷰컨들을 다 지워야 해
        // 지워지지 말아야 할 애들이 붙어있을 리가 없지. 붙어있으면 애초에 구현할 때 문제가 있었던거야
        navigationController.dismiss(animated: true)
        
        
        /*
         LoginScene 코디에게(to LoginScene) 연락이 온다
         1. Child
         2. Child의 Child -> 없음
         3. 부모 타고 가야 하는 코디
         */
        
        
        // 1. Child
            // (SignUpView) 회원가입 성공 -> InitialWorkSpaceView
        if let nextFlow = nextFlow as? ChildCoordinatorType {
            switch nextFlow {
            case .selectAuth:
                print("실행되면 안됨.")
            case .initialWorkSpace:
                print("회원가입 성공 시, initialWorkSpace로 간다")
                self.showInitialWorkSpaceFlow()
            }
        }
        
        // 3. 부모 타고 가야하는 코디
            // (EmailLoginView) 로그인 성공 -> HomeEmptyView
            // (EmailLoginView) 로그인 성공 -> HomeDefaultView
            // (SelectAuthView) 소셜 로그인 성공 -> HomeEmptyView
            // (SelectAuthView) 소셜 로그인 성공 -> HomeDefaultView
            // (InitialWorkSpaceView) x 버튼 -> HomeEmptyView
            // (InitialWorkSpaceView) x 버튼 -> HomeDefaultView
            // (MakeWorkSpaceView) 워크스페이스 생성 -> HomeDefaultView
        else {
            // 이거 하나면 끝남. 그냥 부모 코디한테 던져줘
            self.finish(nextFlow)
            // 어차피 얘가 여기서 뭘 해줄수가 없기 때문에 부모 코디(App코디)한테 nextFlow그대로 던지면 알아서 해줄거다.
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
