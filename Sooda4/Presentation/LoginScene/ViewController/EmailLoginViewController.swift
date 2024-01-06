//
//  LoginViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

class EmailLoginViewController: BaseViewController {
    
    private let mainView = EmailLoginView()
    private var viewModel: EmailLoginViewModel!
    
    static func create(with viewModel: EmailLoginViewModel) -> EmailLoginViewController {
        let vc = EmailLoginViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
    }
    
    func setNavigation() {
        navigationItem.title = "이메일 로그인"
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
