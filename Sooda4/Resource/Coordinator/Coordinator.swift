//
//  Coordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

// MARK: - Coorinator Protocol
protocol Coordinator: AnyObject {
    
    // 1. 부모 코디네이터
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    // 2. 각 코디네이터는 하나의 nav를 갖는다
    var navigationController: UINavigationController { get set }
    init(_ navigationController: UINavigationController)
    
    // 3. 현재 살아있는 자식 코디네이터 배열.
    var childCoordinators: [Coordinator] { get set }
    
    // 4. Flow 타입
    var type: CoordinatorType { get }
    
    // 5. Flow 시작 시점 로직
    func start()
    
    // 6. Flow 종료 시점 로직. (extension에서 선언)
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?)
}

// 모든 코디네이터에서 동일하기 때문에 여기서 미리 선언
extension Coordinator {
    func finish(_ nextFlow: ChildCoordinatorTypeProtocol?) {
        print("😆😆😆😆 Finish 함수 실행!! : \(self.type)")
        print("😆😆😆😆 nav.VCs : \(navigationController.viewControllers)")
        print("😆😆😆😆 nav.presentedVC : \(navigationController.presentedViewController)")
        
        // 1. 자식 코디 다 지우기
        childCoordinators.removeAll()
        
        // 1.3 네비게이션에서 push로 띄운 vc 모두 제거
        navigationController.viewControllers.removeAll()
        
        // 1.5 네비게이션에서 present로 띄운 vc 모두 제거
        navigationController.presentedViewController?.dismiss(animated: false)
        
        
        
        // 2. 부모 코디에게 알리기
        finishDelegate?.coordinatorDidFinish(
            childCoordinator: self,
            nextFlow: nextFlow  
        )
    }
}



// MARK: - Coordinator Finish Delegate
// 부모 코디네이터에게 자식 코디네이터(self)가 이제 끝난다고 알려준다
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator, nextFlow: ChildCoordinatorTypeProtocol?)
}

// MARK: - ChildCoordinatorTypeProtocol
// 각 코디네이터의 자식 코디네이터 타입을 저장. (enum)
// 모든 enum을 매개변수로 받기 위한 프로토콜. (제네릭으로 받을 예정)
protocol ChildCoordinatorTypeProtocol {
    
}


// MARK: - Coordinator Type
// 앱 내에서 어떤 flow를 담당하는지 정의한다
enum CoordinatorType {
    case app
    case splash, loginScene, homeEmptyScene, tabBarScene
    // loginScene
    case selectAuth, initialWorkSpace
    case signUp, emailLogin
    
    // homeEmpty
    
    // tabBar
    case homeDefault, dm, search, setting
    
    // homeDefault
    case workSpaceList, exploreChannel
    
}
