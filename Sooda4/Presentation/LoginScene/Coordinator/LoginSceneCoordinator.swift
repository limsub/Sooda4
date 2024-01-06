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
        
        // TODO: VM - DidSendEventClosure
        // 화면 전환을 위한 Event 받기
        onboardingVM.didSendEventClosure = { [weak self] event in
            
            // didfinish 실행해주기
            
//            switch event {
//            case .presentSelectAuthView:
//                
//            }
        }
        // 전환 - fade 효과, present, fullScreen -> (x)
        setUpViewFadeEffect()
//        onboardingVC.modalPresentationStyle = .fullScreen
//        navigationController.present(onboardingVC, animated: false)
        navigationController.pushViewController(onboardingVC, animated: false)
    }
    
    // 프로토콜 메서드 - flow
    func showSelectAuthFlow() {
        // TODO: selectAuthFlow 시작. present로 진행. 별도의 navigationController 주입
    }
    
    func showInitialWorkSpaceFlow() {
        
    }
    
//    func showSelectAuthView() {
//        print(#function)
//        
//        let selectAuthVM = SelectAuthViewModel()
//        let selectAuthVC = SelectAuthViewController.create(with: selectAuthVM)
//        print("----")
//        
//        // TODO: VM - DidSendEventClosure
//        selectAuthVM.didSendEventClosure = { [weak self] event in
//            switch event {
//            case .presentSignUpView:
//                self?.showSignUpView()
//                
//            }
//        }
//        
//        // 전환 - bottom sheet
//        navigationController.present(selectAuthVC, animated: true)
//        
//        print(navigationController.viewControllers)
////        navigationController.pushViewController(selectAuthVC, animated: true)
//    }
//    
//    func showSignUpView() {
//        print(#function)
//        
//        let signUpVM = SignUpViewModel()
//        let signUpVC = SignUpViewController.create(with: signUpVM)
//        
//        
//        // 얘가 호출된다는건 SelectAuthVC에서 눌렸다.
//        // 그렇다는건 nav의 vc들 중 맨 마지막에 SelectAuthVC가 있다. -> 확실?
//        
//        let vc = navigationController.viewControllers.last
//        vc?.present(signUpVC, animated: true)
////        navigationController.viewControllers.last!.present(signUpVC, animated: true)
////        
//        print(navigationController.viewControllers)
////        
////        navigationController.viewControllers.forEach { vc in
////            if let selectAuthVC = vc as? SelectAuthViewController {
////                print("hi")
////            }
////        }
//        
//        // TODO: VM - DidSendEventClosure
//        
////        navigationController.present(signUpVC, animated: true)
////        navigationController.pushViewController(signUpVC, animated: true)
//    }
//    
//    func showLoginView() {
//        print(#function)
//        
//        let loginVM = LoginViewModel()
//        let loginVC = LoginViewController.create(with: loginVM)
//        
//        // TODO: VM - DidSendEventClosure
//        
//        navigationController.pushViewController(loginVC, animated: true)
//    }
//    
//    func showInitialWorkSpaceView() {
//        print(#function)
//        
//        let intialWorkSpaceVM = InitialWorkSpaceViewModel()
//        let initialWorkSpaceVC = InitialWorkSpaceViewController.create(with: intialWorkSpaceVM)
//        
//        // TODO: VM - DidSendEventClosure
//        
//        navigationController.pushViewController(initialWorkSpaceVC, animated: true)
//    }
}

// MARK: - Child DidFinished
extension LoginSceneCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function, Swift.type(of: self))
        
        print("-- 자식 코디가 끝났다는 소식 들었으니까 처리해주자 - 받는 입장")
        
        // 얘 자식은 SelectAuth 아니면 InitialWorkSpace
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
