//
//  SplashViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

class SplashViewController: BaseViewController {
    
    private let mainView = SplashView()
    private var viewModel: SplashViewModel!
    
    static func create(with viewModel: SplashViewModel) -> SplashViewController {
        let vc = SplashViewController()
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
