//
//  SelectAuthViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

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
        
        
    }
}
