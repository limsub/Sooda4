//
//  InviteMemberViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class InviteMemberViewController: BaseViewController {
    
    let mainView = InviteMemberView()
    var viewModel: InviteMemberViewModel!
    
    static func create(with viewModel: InviteMemberViewModel) -> InviteMemberViewController {
        let vc = InviteMemberViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("팀원 초대")
    }
}
