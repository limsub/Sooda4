//
//  WorkSpaceListCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import UIKit


protocol WorkSpaceListCoordinatorProtocol: Coordinator {
    // view
    func showMakeWorkSpaceView()
    func showEditWorkSpaceView()
    func showExitWorkSpaceView()    // 팝업
    func showDeleteWorkSpaceView()  // 팝업
    func showChangeAdminView()
}

class WorkSpaceListCoordinator: WorkSpaceListCoordinatorProtocol {
    
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
    var type: CoordinatorType = .workSpaceList
    
    // 5.
    func start() {
        showMakeWorkSpaceView()
    }
    
    func showMakeWorkSpaceView() {
        print(#function)
    }
    func showEditWorkSpaceView() {
        print(#function)
    }
    func showExitWorkSpaceView() {
        print(#function)
    }
    func showDeleteWorkSpaceView() {
        print(#function)
    }
    func showChangeAdminView() {
        print(#function)
    }
}
