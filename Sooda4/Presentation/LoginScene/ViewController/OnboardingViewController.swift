//
//  OnboardingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import SideMenu

final class OnboardingViewController: BaseViewController {
    
    private let mainView = OnboardingView()
    private var viewModel: OnboardingViewModel!
    
    static func create(with viewModel: OnboardingViewModel) -> OnboardingViewController {
        let vc = OnboardingViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainView.nextButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        title = "온보딩 뷰"
        
    }
        
    @objc
    func buttonClicked() {
        viewModel.didSendEventClosure?(.presentSelectAuthView)
    }
    
}

