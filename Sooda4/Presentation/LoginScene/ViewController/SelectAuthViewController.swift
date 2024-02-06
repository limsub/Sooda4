//
//  SelectAuthViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class SelectAuthViewController: BaseViewController {
    
    private let mainView = SelectAuthView()
    private var viewModel: SelectAuthViewModel!
    
    static func create(with viewModel: SelectAuthViewModel) -> SelectAuthViewController {
        let vc = SelectAuthViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVM()
    }
    
    override func setting() {
        super.setting()
        
        // medium sheet presentation 세팅
        if let sheetPresentationController = sheetPresentationController {
            
            let customDetentId = UISheetPresentationController.Detent.Identifier("custom")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: customDetentId) { context in
                return 279
            }
            
            sheetPresentationController.detents = [customDetent]
            sheetPresentationController.prefersGrabberVisible = true
        }
    }
    
    func bindVM() {
        let input = SelectAuthViewModel.Input(
            appleLoginButtonClicked: mainView.appleLoginButton.rx.tap,
            kakaoLoginButtonClicked: mainView.kakaoLoginButton.rx.tap,
            emailLoginButtonClicked: mainView.emailLoginButton.rx.tap,
            signUpButtonClicked: mainView.signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        
    }

}
