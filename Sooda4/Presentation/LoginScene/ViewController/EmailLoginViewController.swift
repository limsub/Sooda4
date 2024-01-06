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
        
        
    }
}
