//
//  InitialWorkSpaceViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

class InitialWorkSpaceViewController: BaseViewController {
    
    private let mainView = InitialWorkSpaceView()
    private var viewModel: InitialWorkSpaceViewModel!
    
    static func create(with viewModel: InitialWorkSpaceViewModel) -> InitialWorkSpaceViewController {
        let vc = InitialWorkSpaceViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.b1.addTarget(self , action: #selector(b1Clicked), for: .touchUpInside)
        mainView.b2.addTarget(self , action: #selector(b2Clicked), for: .touchUpInside)
    }
    
    
    @objc
    func b1Clicked() {
        print(#function)
        viewModel.didSendEventClosure?(.goHomeEmptyView)
    }
    
    @objc
    func b2Clicked() {
        print(#function)
        viewModel.didSendEventClosure?(.goMakeWorkSpaceView)
    }
}
