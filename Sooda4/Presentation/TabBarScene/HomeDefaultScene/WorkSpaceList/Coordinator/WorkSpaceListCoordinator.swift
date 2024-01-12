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
    var handleWorkSpaceUseCase: HandleWorkSpaceUseCaseProtocol { get set }
    
    
    
    // view
    func showWorkSpaceListView()
    
    func showMakeWorkSpaceView()
    
    func showEditWorkSpaceView()
    func showExitWorkSpaceView(isAdmin: Bool)    // 팝업
    func showDeleteWorkSpaceView()  // 팝업
    func showChangeAdminView()
}

class WorkSpaceListCoordinator: WorkSpaceListCoordinatorProtocol {
    
    var handleWorkSpaceUseCase: HandleWorkSpaceUseCaseProtocol
    
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    // 2.
    var navigationController: UINavigationController
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        handleWorkSpaceUseCase = HandleWorkSpaceUseCase(
            handleWorkSpaceRepository: HandleWorkSpaceRepository(),
            workSpaceRepository: WorkSpaceRepository()
        )
        // 여기다 이렇게 써두니까 그냥 개판이고만. Layer 분리 전혀 안되네..
    }
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .workSpaceList
    
    // 5.
    func start() {
        showWorkSpaceListView()
    }
    
    // * 필수
    var workSpaceId: Int?
    
    func showWorkSpaceListView() {
        
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
                    self?.showChangeAdminView()
                    
                }, fourthTitle: "워크스페이스 삭제") {
                    print("4")
                    self?.showDeleteWorkSpaceView()
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
    
    
    
    func showMakeWorkSpaceView() {
        print(#function)
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
                    
                    // 코디네이터에서 이런 식으로 네트워크 콜 하고 있는게 문제가 있는 것 같다.
                    // 근데 내가 팝업창을 요따구로 구현해둬서, 따로 VC, VM이 있는 구조가 아니기 때문에 어쩔 수 없다고 판단함.
                    // 예외적으로 여기 코디에서만 UseCase를 활용하자
                    self.handleWorkSpaceUseCase.leaveWorkSpaceRequest(
                        self.workSpaceId!
                    ) { response  in
                        switch response {
                        case .success(let model):
                            // 남은 워크스페이스 유무에 따라 어디로 갈 지 정해진다.
                            if model.isEmpty {
                                print("남은 워크스페이스가 없다. Home Empty로 가자")
                                print("워크스페이스코디 : finish 실행")
                                self.finish(AppCoordinator.ChildCoordinatorType.homeEmptyScene)
                                
                                
                                
                            } else {
                                print("남은 워크스페이스 중 created가 가장 최근 날짜(createdAt)에 생성된 워크스페이스로 가야하는데 지금 일단 귀찮아서 배열 첫 번째 워크스페이스로 감")
                                
                                /* 여기서 뒤로 돌아가는 로직은 워크스페이스 선택했을 때와 동일함 */
                                
                                let newWorkSpaceId = model.first!.workSpaceId
                                self.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: newWorkSpaceId))
                            }
                            
                        case .failure(let networkError):
                            // 관리자인 채널이 하나 있어서 실패한 경우에는 채널 관리자 때문이라고 토스트 메세지 띄워주기
                            
                            if case .E15 = networkError {
                                print("채널 관리자입니다!!")
                                
                            } else {
                                print("그냥 에러남")
                            }
                            
                            self.navigationController.dismiss(animated: false)
                            
                        }
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
        // 관리자일 때만 실행되는 코드이기 때문에, 따로 분기처리할 필요 없다
        
        // "나가기" 클릭했을 때와 거의 비슷.
        // 단, 여기서는 추가로 남은 워크스페이스 정보에 대한 네트워크 콜을 해야 함
        
        
        navigationController.showCustomAlertTwoActionViewController(
            title: "워크스페이스 삭제",
            message: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다",
            okButtonTitle: "삭제",
            cancelButtonTitle: "취소") {
                print("삭제 클릭")
                
                self.handleWorkSpaceUseCase.deleteWorkSpaceRequest(
                    self.workSpaceId!
                ) { response  in
                    switch response {
                    case .success:
                        print("워크스페이스 삭제 성공. 내 워크스페이스 조회 통신 시도")
                        
                        self.handleWorkSpaceUseCase.myWorkSpaceRequest { response  in
                            switch response {
                            case .success(let model):
                                print("내 워크스페이스 조회 성공")
                                
                                if model.isEmpty {
                                    print("남은 워크스페이스가 없다. Home Empty로 가자")
                                    self.finish(AppCoordinator.ChildCoordinatorType.homeEmptyScene)
                                    
                                } else {
                                    print("남은 워크스페이스 중 created가 가장 최근 날짜(createdAt)에 생성된 워크스페이스로 가야하는데 지금 일단 귀찮아서 배열 첫 번째 워크스페이스로 감")
                                    
                                    /* 여기서 뒤로 돌아가는 로직은 워크스페이스 선택했을 때와 동일함 */
                                    
                                    let newWorkSpaceId = model.first!.workSpaceId
                                    self.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: newWorkSpaceId))
                                }

                            case .failure(let error):
                                print("내 워크스페이스 조회 실패")
                                self.navigationController.dismiss(animated: false)
                            }
                        }
                    case .failure(let networkError):
                        print("워크스페이스 삭제 실패")
                        self.navigationController.dismiss(animated: false)
                    }
                }
                
            } cancelCompletion: {
                print("취소 클릭")
                
                self.navigationController.dismiss(animated: false)
            }


        
        
    }
    
    
    func showChangeAdminView() {
        print(#function)
        
        let changeAdminVM = ChangeAdminViewModel(
            // 자기 쓰는거 전달해줌.
            handleWorkSpaceUseCase: self.handleWorkSpaceUseCase
        )
        let changeAdminVC = ChangeAdminViewController.create(with: changeAdminVM)
        
        changeAdminVM.didSendEventClosure = { [weak self] event in
            print("hi")
        }
        
        let nav = UINavigationController(rootViewController: changeAdminVC)
        navigationController.present(nav, animated: true)
    }
}



