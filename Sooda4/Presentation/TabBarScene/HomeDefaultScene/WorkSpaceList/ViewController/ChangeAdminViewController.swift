//
//  ChangeAdminViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import UIKit

class ChangeAdminViewController: BaseViewController {
    
    var viewModel: ChangeAdminViewModel!
    
    
    static func create(with viewModel: ChangeAdminViewModel) -> ChangeAdminViewController {
        let vc = ChangeAdminViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
    }
    
    func setNavigation() {
        navigationItem.title = "워크스페이스 관리자 변경"
        if let sheetPresentationController {
            sheetPresentationController.prefersGrabberVisible = true
        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
//        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
}
