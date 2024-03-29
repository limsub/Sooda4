//
//  ExploreChannelCoordinator.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit

protocol ExploreChannelCoordinatorProtocol: Coordinator {
    
    var workSpaceId: Int? { get set }
    
    // view
    func showExploreChannelView(_ workSpaceId: Int) // firstView
    func showChannelChattingView(workSpaceId: Int, channelId: Int, channelName: String )
    func showChannelSettingView(_ workSpaceId: Int, channelName: String, isAdmin: Bool)
    

    
    // setting 세부 뷰 (나가기, 삭제는 VC 에서 팝업으로 처리)
    // workspace 할 때, 여기서 UseCase를 쓰는 게 별로였음.
    func showEditChannelView(_ workSpaceId: Int, channelName: String)
    func showChangeAdminView(_ workSpaceId: Int, channelName: String)
    
}

class ExploreChannelCoordinator: ExploreChannelCoordinatorProtocol {
    
    
    var workSpaceId: Int?
    
    // 1.
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    // 2.
    var navigationController: UINavigationController
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    convenience init(workSpaceId: Int?, nav: UINavigationController) {
        self.init(nav)
        self.workSpaceId = workSpaceId
    }
    
    
    // 3.
    var childCoordinators: [Coordinator] = []
    
    // 4.
    var type: CoordinatorType = .exploreChannel
    
    // 5.
    func start() {
        guard let workSpaceId else { return }
        showExploreChannelView(workSpaceId)
    }
    
    // 프로토콜 메서드 - view
    func showExploreChannelView(_ workSpaceId: Int) {
        print(#function)
        
        let exploreChannelVM = ExploreChannelViewModel(
            workSpaceId: workSpaceId, exploreChannelUseCase: ExploreChannelUseCase(exploreChannelRepository: ExploreChannelRepository()))
        
        exploreChannelVM.didSendEventClosure = { [weak self] event in
            switch event {
            case .goChannelChatting(let workSpaceId, let channelId, let channelName):
                
                self?.showChannelChattingView(
                    workSpaceId: workSpaceId,
                    channelId: channelId,
                    channelName: channelName
                )
                
            case .goBackHomeDefault(let workSpaceId):
                self?.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: workSpaceId))
            }
            
        }
        
        let exploreChannelVC = ExploreChannelViewController.create(with: exploreChannelVM)
        
        navigationController.pushViewController(exploreChannelVC, animated: false)
    }
    
    func showChannelChattingView(workSpaceId: Int, channelId: Int, channelName: String ) {
        print(#function)
        
        let channelChattingVM = ChannelChattingViewModel(
            workSpaceId: workSpaceId,
            channelId: channelId,
            channelName: channelName,
            channelChattingUseCase: ChannelChattingUseCase(
                channelInfoRepository: ChannelInfoRepository(),
                channelChattingRepository: ChannelChattingRepository(),
                socketChannelChattingRepository: SocketChannelChattingRepository()
            )
        )
   
        
        channelChattingVM.didSendEventClosure = { [weak self] event in
            switch event {
            case .goBackHomeDefault(let workSpaceId):
                // finish(homeDefault)
                break
            case .goChannelSetting(let workSpaceId, let channelName):
                self?.showChannelSettingView(workSpaceId, channelName: channelName, isAdmin: true)
        
            }
            
        }
        
        let channelChattingVC = ChannelChattingViewController.create(with: channelChattingVM)
        
        navigationController.pushViewController(channelChattingVC, animated: true)
    }
    
    func showChannelSettingView(_ workSpaceId: Int, channelName: String, isAdmin: Bool) {
        print(#function)
        
        let channelSettingVM = ChannelSettingViewModel(
            workSpaceId: workSpaceId,
            channelName: channelName,
            channelSettingUseCase: ChannelSettingUseCase(channelSettingRepository: ChannelSettingRepository()),
            handleChannelUseCase: HandleChannelUseCase(handleChannelRepository: HandleChannelRepository())
        )
        
        channelSettingVM.didSendEventClosure = { [weak self] event in
            
            // 채널 편집,  채널 관리자 변경 (나가기, 삭제는 VC에서 처리)
            switch event {
            case .presentChangeAdminChannel(let workSpaceId, let channelName):
                self?.showChangeAdminView(workSpaceId, channelName: channelName)
                
            case .presentEditChannel(let workSpaceId, let channelName):
                self?.showEditChannelView(workSpaceId, channelName: channelName)
                
            case .goBackHomeDefault(let workSpaceId):
                self?.finish(TabBarCoordinator.ChildCoordinatorType.homeDefaultScene(workSpaceId: workSpaceId))
            }
        }
        
        let channelSettingVC = ChannelSettingViewController.create(with: channelSettingVM)
        
        navigationController.pushViewController(channelSettingVC, animated: true)
    }
    
    func showEditChannelView(_ workSpaceId: Int, channelName: String) {
        print(#function)
        // 채널 편집 화면
        
        let editChannelVM = MakeChannelViewModel(
            makeChannelUseCase: MakeChannelUseCase(
                makeChannelRepository: MakeChannelRepository(),
                oneChannelInfoRepository: ChannelSettingRepository()
            ),
            handleChannelUseCase: HandleChannelUseCase(handleChannelRepository: HandleChannelRepository()),
            workSpaceId: workSpaceId,
            type: .edit(workSpaceId: workSpaceId, channelName: channelName)
        )
        editChannelVM.didSendEventClosure = { [weak self] event in
            switch event {
            case .goBackChannelSetting(let newChannelName):
                print("---123-132-")
                self?.navigationController.dismiss(animated: true)
                
                // channel setting view를 업데이트시켜줘야 함
                self?.navigationController.viewControllers.forEach({ vc in
                    
                    if let vc = vc as? ChannelSettingViewController {
                        
                        vc.reloadData(
                            workSpaceId: workSpaceId,
                            channelName: newChannelName
                        )
                    }
                })
                
            default: break
            }
        }
        
        let editChannelVC = MakeChannelViewController.create(with: editChannelVM)
        let nav = UINavigationController(rootViewController: editChannelVC)
        
        navigationController.present(nav, animated: true)
    }
    
    func showChangeAdminView(_ workSpaceId: Int, channelName: String) {
        print(#function)
        // 채널 관리자 변경 화면
        
        let changeAdminChannelVM = ChangeAdminChannelViewModel(
            workSpaceId: workSpaceId,
            channelName: channelName,
            handleChannelUseCase: HandleChannelUseCase(handleChannelRepository: HandleChannelRepository())
        )
        changeAdminChannelVM.didSendEventClosure = { [weak self] event in
            
            switch event {
            case .goBackChannelSetting:
                print("---123-132-")

                
                
                // channel setting view를 업데이트시켜줘야 함
                self?.navigationController.viewControllers.forEach({ vc in
                    
                    if let vc = vc as? ChannelSettingViewController {
                        
                        vc.reloadData(
                            workSpaceId: workSpaceId,
                            channelName: nil
                        )
                    }
                })
                
            }
        }
            
        let changeAdminChannelVC = ChangeAdminChannelViewController.create(with: changeAdminChannelVM)
        
        let nav = UINavigationController(rootViewController: changeAdminChannelVC)
        
        navigationController.present(nav, animated: true)
    }
}
