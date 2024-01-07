////
////  HomeEmptySceneCoordinator.swift
////  Sooda4
////
////  Created by 임승섭 on 1/7/24.
////
//
//import UIKit
//
//// MARK: - HomeEmptyScene Coordinator Protocol
//protocol HomeEmptySceneCoordinatorProtocol: Coordinator {
//    
//    // view
//    func showHomeEmptyView()
//    func showMakeWorkSpaceView()
//    
//    // startViewType
//    var startViewType: HomeEmptySceneCoordinatorStartViewType  { get }
//}
//
//enum HomeEmptySceneCoordinatorStartViewType {
//    case homeEmptyView
//    case makeWorkSpace
//}
//
//
//// MARK: - HomeEmptyScene Coordinator Class
//class HomeEmptySceneCoordinator: HomeEmptySceneCoordinatorProtocol {
//    
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
//    var type: CoordinatorType = .homeEmptyScene
//    
//    // 5. - 두 개 필요 (HomeEmptyView)
//    func start() {
//    
//    }
//    
//    // 6.
//    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
//        <#code#>
//    }
//    
//    // 프로토콜 프로퍼티
//    // 생성 시 변경
//    var startViewType: HomeEmptySceneCoordinatorStartViewType = .homeEmptyView
//    
//    // 프로토콜 메서드 - view
//    func showHomeEmptyView() {
//        <#code#>
//    }
//    
//    func showMakeWorkSpaceView() {
//        <#code#>
//    }
//}
