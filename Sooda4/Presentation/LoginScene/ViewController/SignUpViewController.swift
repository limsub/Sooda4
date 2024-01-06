//
//  SignUpViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    private let mainView = SignUpView()
    private var viewModel: SignUpViewModel!
    
    static func create(with viewModel: SignUpViewModel) -> SignUpViewController {
        let vc = SignUpViewController()
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
        navigationItem.title = "회원가입"
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
