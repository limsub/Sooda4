//
//  ExploreChannelViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class ExploreChannelViewController: BaseViewController {
    
    
    private let mainView = ExploreChannelView()
    private var viewModel: ExploreChannelViewModel!
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: ExploreChannelViewModel) -> ExploreChannelViewController {
        let vc = ExploreChannelViewController()
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
