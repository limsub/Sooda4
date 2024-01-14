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
    func showJoinChannelView(_ workSpaceId: Int, channelId: Int)
    func showDetailChannelView(_ workSpaceId: Int, channelId: Int, isAdmin: Bool)
    
    
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
        let exploreChannelVC = ExploreChannelViewController.create(with: exploreChannelVM)
        
        navigationController.pushViewController(exploreChannelVC, animated: false)
    }
    
    func showJoinChannelView(_ workSpaceId: Int, channelId: Int) {
        print(#function)
    }
    
    func showDetailChannelView(_ workSpaceId: Int, channelId: Int, isAdmin: Bool) {
        print(#function)
    }
}