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
    
    // 6.
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
        // 전달하는 곳
        childCoordinators.removeAll()   // 없어 이건
        
        finishDelegate?.coordinatorDidFinish(
            childCoordinator: self ,
            nextFlow: nextFlow
        )
    }
    
    // 프로토콜 메서드 - view
    func showSelectAuthView() {
        let selectAuthVM = SelectAuthViewModel()
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
            )
        )
        let emailLoginVC = EmailLoginViewController.create(with: emailLoginVM)
        
        let nav = UINavigationController(rootViewController: emailLoginVC)
        
        navigationController.present(nav, animated: true)
    }
}

// MARK: - Child Did Finished
extension SelectAuthCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?) {
        print(#function, Swift.type(of: self))
        
        print("- 자식 코디 없음. 이거 실행되면 문제 있는거임")
        
        // 이게 왔다는 건 이메일 완료 아니면 회원가입 완료이기 때문에
        // 아래 코디네이터 끝났다 -> 얘도 끝나야 함.
        // -> nextFlow가 뭔지 그대로 위로 전달해줘
        // 즉, 얘 자식 코디에서 nextFlow로 넣은 매개변수가 얘보다 위 계층의 코디일거야
    }
}

// MARK: - Child Coordinator Type
extension SelectAuthCoordinator {
    enum ChildCoordinatorType: ChildCoordinatorTypeProtocol {
        case signUp, emailLogin
    }
}


