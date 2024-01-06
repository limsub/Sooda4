////
////  SignUpCoordinator.swift
////  Sooda4
////
////  Created by 임승섭 on 1/6/24.
////
//
//import UIKit
//
//// MARK: - SignUp Coordinator Protocol
//protocol SignUpCoordinatorProtocol: Coordinator {
//    // view
//    func showSignUpView()
//}
//
//// MARK: - SignUP Coordinator Class
//class SignUpCoordinator: SignUpCoordinatorProtocol {
//    // 1.
//    weak var finishDelegate: CoordinatorFinishDelegate?
//    
//    // 2.
//    var navigationController: UINavigationController
//    required init(_ navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    // 3.
//    var childCoordinators: [Coordinator] = []
//    
//    // 4.
//    var type: CoordinatorType = .signUp
//    
//    // 5.
//    func start() {
//        showSignUpView()
//    }
//    
//    // 6.
//    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
//        <#code#>
//    }
//}
