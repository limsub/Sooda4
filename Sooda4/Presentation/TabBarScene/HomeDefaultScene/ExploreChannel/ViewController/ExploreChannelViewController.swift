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
        
        setNavigation("채널 탐색")
        bindVM()
    }
    
    let a = BehaviorSubject(value: ["a", "asbd", "adfas"])
    
    func bindVM() {
        a.bind(to: mainView.tableView.rx.items(cellIdentifier: HomeDefaultChannelTableViewCell.description(), cellType: HomeDefaultChannelTableViewCell.self)) { (row, element, cell) in
            
            cell.designWithBold(element)
        }
        .disposed(by: disposeBag)
    }
}
