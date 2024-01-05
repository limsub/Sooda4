//
//  LoginViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    private var viewModel: LoginViewModel!
    
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        let vc = LoginViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
