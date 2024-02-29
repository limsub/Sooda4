//
//  MyProfileViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class MyProfileViewController: BaseViewController {
    
    private let mainView = MyProfileView()
    private var viewModel: MyProfileViewModel!
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: MyProfileViewModel) -> MyProfileViewController {
        
        let vc = MyProfileViewController()
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
