//
//  SelectAuthCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import UIKit

// MARK: - SelectAuth Coordinator Protocol
protocol SelectAuthCoordinatorProtocol: Coordinator {
    // view
    func showSelectAuthView()   // first
    
    func showSignUpView()       // present
    func showEmailLoginView()   // present
}

// MARK: - SelectAuth Coordinator Class
class SelectAuthCoordinator: SelectAuthCoordinatorProtocol {
    
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
    var type: CoordinatorType = .selectAuth
    
    // 5.
    func start() {
        showSelectAuthView()
    }
    
    // 프로토콜 메서드 - view
    func showSelectAuthView() {
        let selectAuthVM = SelectAuthViewModel(
            socialLoginUseCase: SocialLoginUseCase(
                socialLoginRepository: SocialLoginRepository()
            )
        )
        let selectAuthVC = SelectAuthViewController.create(with: selectAuthVM)
        
        selectAuthVM.didSendEventClosure = { [weak self] event in
            switch event {
            case .presentSignUpView:
                self?.showSignUpView()
                
            case .presentEmailLoginView:
                self?.showEmailLoginView()
            }
        }
        
        navigationController.pushViewController(selectAuthVC, animated: false)
    }
    
    func showSignUpView() {
        let signUpVM = SignUpViewModel(
            signUpUseCase: SignUpUseCase(
                signUpRepository: SignUpRepository(),
                signInRepository: SignInRepository()
            )
        )
        let signUpVC = SignUpViewController.create(with: signUpVM)
        
        // TODO: didSendEvent
        // 회원가입 성공했다.
        // -> 현재 SelectAuth 코디 종료하고 InitialWorkSpace코디 실행
        signUpVM.didSendEventClosure = { [weak self] event in
            
            self?.finish(LoginSceneCoordinator.ChildCoordinatorType.initialWorkSpace)
        }
        
        
        // 회원가입 화면에 네비게이션 바가 있어서 달아주는 게 더 편할듯
        let nav = UINavigationController(rootViewController: signUpVC)
        
        navigationController.present(nav, animated: true)
    }
    
    func showEmailLoginView() {
        let emailLoginVM = EmailLoginViewModel(
            signUpUseCase: SignUpUseCase(
                signUpRepository: SignUpRepository(),
                signInRepository: SignInRepository()
            ),
            workSpaceUseCase: WorkSpaceUseCase(
                workSpaceRepository: WorkSpaceRepository()
            )
        )
        let emailLoginVC = EmailLoginViewController.create(with: emailLoginVM)
        
        emailLoginVM.didSendEventClosure = { [weak self] event in
            
            switch event {
            case .goHomeDefaultView(let workSpaceId):
                self?.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: workSpaceId))
                
            case .goHomeEmptyView:
                self?.finish(AppCoordinator.ChildCoordinatorType.homeEmptyScene)
                
            }
        }
        
        let nav = UINavigationController(rootViewController: emailLoginVC)
        
        navigationController.present(nav, animated: true)
    }
    
    
    deinit {
        print("😀😀😀😀😀😀😀  select auth Coordinator deinit")
    }
}


// MARK: - Child Coordinator Type
extension SelectAuthCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case signUp, emailLogin
    }
}


