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
    func showSelectAuthView()
    func showSignUpView()
    func showLoginView()
    func showInitialWorkSpaceView()
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
        // 스플래시 뷰에서 넘어오기 때문에 맨 처음에는 present transition 으로 전환이 필요해
        showOnboardingView()
    }
    
    // 프로토콜 메서드
    func showOnboardingView() {
        print(#function)
        
        let onboardingVM = OnboardingViewModel()
        let onboardingVC = OnboardingViewController.create(with: onboardingVM)
        
        // TODO: VM - DidSendEventClosure
        
//        navigationController.pushViewController(onboardingVC, animated: true)
        
        setUpViewFadeEffect()
        onboardingVC.modalPresentationStyle = .fullScreen
        navigationController.present(onboardingVC, animated: false)
    }
    
    func showSelectAuthView() {
        print(#function)
        
        let selectAuthVM = SelectAuthViewModel()
        let selectAuthVC = SelectAuthViewController.create(with: selectAuthVM)
        
        // TODO: VM - DidSendEventClosure
        
        navigationController.pushViewController(selectAuthVC, animated: true)
    }
    
    func showSignUpView() {
        print(#function)
        
        let signUpVM = SignUpViewModel()
        let signUpVC = SignUpViewController.create(with: signUpVM)
        
        // TODO: VM - DidSendEventClosure
        
        navigationController.pushViewController(signUpVC, animated: true)
    }
    
    func showLoginView() {
        print(#function)
        
        let loginVM = LoginViewModel()
        let loginVC = LoginViewController.create(with: loginVM)
        
        // TODO: VM - DidSendEventClosure
        
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func showInitialWorkSpaceView() {
        print(#function)
        
        let intialWorkSpaceVM = InitialWorkSpaceViewModel()
        let initialWorkSpaceVC = InitialWorkSpaceViewController.create(with: intialWorkSpaceVM)
        
        // TODO: VM - DidSendEventClosure
        
        navigationController.pushViewController(initialWorkSpaceVC, animated: true)
    }
}

// MARK: - Child DidFinished
extension LoginSceneCoordinator: CoordinatorFinishDelegate {
    // 애초에 자식 코디네이터가 없기 때문에 얜 실행되지 않을거야
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("이게 실행될 리가 없어...")
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
