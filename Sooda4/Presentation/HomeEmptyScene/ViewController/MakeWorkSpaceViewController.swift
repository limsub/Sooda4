//
//  MakeWorkSpaceViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit

class MakeWorkSpaceViewController: BaseViewController {
    
    let mainView = MakeWorkSpaceView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
    }
}
