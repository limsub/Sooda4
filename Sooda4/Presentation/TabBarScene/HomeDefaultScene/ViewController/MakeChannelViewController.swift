//
//  MakeChannelViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class MakeChannelViewController: BaseViewController {
    
    private let mainView = MakeChannelView()
    private var viewModel: MakeChannelViewModel!
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: MakeChannelViewModel) -> MakeChannelViewController {
        let vc = MakeChannelViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("채널 생성")
    }
}
