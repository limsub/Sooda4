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
    }
}
