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
    
    // * 필수
    var workSpaceId: Int?
    
    func showMakeWorkSpaceView() {
        
        guard let workSpaceId else { return }
        
        let workSpaceListVM = WorkSpaceListViewModel(
            workSpaceUseCase: WorkSpaceUseCase(
                workSpaceRepository: WorkSpaceRepository()
            ),
            selectedWorkSpaceId: workSpaceId
        )
        
        workSpaceListVM.didSendEventClosure = { [weak self] event in
            
            
            switch event {
            case .goBackHomeDefault(let newWorkSpaceId):
                // (워크스페이스 리스트 중 하나 선택) dismiss되고 homeDefaultView reload
                self?.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: newWorkSpaceId))  // 새로운 workspace id 전달
                // -> 여기에 대한 처리는 HomeDefault에서 굳이굳이 케이스 나눠서 판단해보자
            }
           
            
            print("kkkkkkkkkkkkkk")
            print(event)
            
        }
        
        
        
        let vc = WorkSpaceListViewController.create(with: workSpaceListVM)
        
        
        navigationController.pushViewController(vc, animated: false)
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
