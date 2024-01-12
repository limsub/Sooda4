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
                
                
            case .showActionSheetForAdmin:
                print("관리자 액션 시트 띄워주기")
//                self?.navigationController.showActionSheetFourSection(firstTitle: "1", firstCompletion: {
//                    print("1")
//                }, secondTitle: "2", secondCompletion: {
//                    print("2")
//                }, thirdTitle: "3", thirdCompletion: {
//                    print("3")
//                }, fourthTitle: "4") {
//                    print("4")
//                }
                
//                self?.navigationController.showCustomAlertOneActionViewController(title: "워크스페이스 나가기", message: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다", completion: {
//                    print("hi")
//                })
                
                self?.navigationController.showCustomAlertTwoActionViewController()
                                
                
                
                
                
                
                
                
            case .showActionSheetForGeneral:
                print("일반 액션 시트 띄워주기")
                self?.navigationController.showActionSheetOneSection(title: "1", completion: {
                    print("1")
                })
            }
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
