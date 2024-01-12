//
//  WorkSpaceListCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import UIKit


protocol WorkSpaceListCoordinatorProtocol: Coordinator {
    // 팝업창을 UIVC 메서드로 구현했기 때문에, 팝업창 내에서 일어나는 일들을 여기 코디네이터에서 처리해줘야 함 <- 워크스페이스 나가기 / 삭제
    // UseCase 하나를 가지고 있는 걸로 하자.
    
    // view
    func showMakeWorkSpaceView()
    
    func showEditWorkSpaceView()
    func showExitWorkSpaceView(isAdmin: Bool)    // 팝업
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
                self?.navigationController.showActionSheetFourSection(
                    firstTitle: "워크스페이스 편집", firstCompletion: {
                    print("1")
                }, secondTitle: "워크스페이스 나가기", secondCompletion: {
                    print("2")
                    self?.showExitWorkSpaceView(isAdmin: true)
                    
                    
                }, thirdTitle: "워크스페이스 관리자 변경", thirdCompletion: {
                    print("3")
                }, fourthTitle: "워크스페이스 삭제") {
                    print("4")
                }
                                
                
            case .showActionSheetForGeneral:
                print("일반 액션 시트 띄워주기")
                self?.navigationController.showActionSheetOneSection(title: "워크스페이스 나가기", completion: {
                    self?.showExitWorkSpaceView(isAdmin: false)
                })
            }
        }
        
        
        
        let vc = WorkSpaceListViewController.create(with: workSpaceListVM)
        
        
        navigationController.pushViewController(vc, animated: false)
    }
    func showEditWorkSpaceView() {
        print(#function)
    }
    func showExitWorkSpaceView(isAdmin: Bool) {
        // 관리자 -> 나가기 불가능 oneAction
        // 일반  -> 나가기 가능   twoAction
        
        if isAdmin {
            navigationController.showCustomAlertOneActionViewController(
                title: "워크스페이스 나가기",
                message: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다") {
                    self.navigationController.dismiss(animated: false)
                }
            
        } else {
            navigationController.showCustomAlertTwoActionViewController(
                title: "워크스페이스 나가기",
                message: "정말 이 워크스페이스를 떠나시겠습니까?",
                okButtonTitle: "나가기",
                cancelButtonTitle: "취소") {
                    // 나가기
                    
                    // 로직 정리
                    // 1. 나가기 네트워크 콜
                    // 2. 실패
                    
                    // 코디네이터에서 이런 식으로 네트워크 콜 하고 있는게 문제가 있는 것 같다.
                    // 근데 내가 팝업창을 요따구로 구현해둬서, 따로 VC, VM이 있는 구조가 아니기 때문에 어쩔 수 없다고 판단함.
                    // 예외적으로 여기서만 NetworkManager에 직접 접근한다
                    
                    NetworkManager.shared.requestCompletion(
                        type: <#T##Decodable.Protocol#>,
                        api: <#T##NetworkRouter#>) { <#Result<Decodable, NetworkError>#> in
                            <#code#>
                        }
                    
                } cancelCompletion: {
                    // 취소
                    self.navigationController.dismiss(animated: false)
                    
                }

            
        }
        print(#function)
    }
    func showDeleteWorkSpaceView() {
        print(#function)
    }
    func showChangeAdminView() {
        print(#function)
    }
}



