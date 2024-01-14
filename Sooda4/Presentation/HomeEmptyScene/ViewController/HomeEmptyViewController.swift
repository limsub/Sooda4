//
//  HomeEmptyViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit
import RxSwift
import RxCocoa

class HomeEmptyViewController: BaseViewController {
    
    let mainView = HomeEmptyView()
    var viewModel: HomeEmptyViewModel!
    
    static func create(with viewModel: HomeEmptyViewModel) -> HomeEmptyViewController {
        let vc = HomeEmptyViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    // Navigation 영역의 객체들
    let customNavigationItemView = UIButton()
    let leftImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "profile_No Photo A")
        return view
    }()
    let navigationTitleLabel = {
        let view = UILabel()
        view.text = "No WorkSpace"
        view.setAppFont(.title1)
        return view
    }()
    let rightImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.image = UIImage(named: "profile_No Photo B")
        view.layer.borderColor = UIColor(hexCode: "#323538").cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green

       
//        setNavigation()
        setCustomNavigation(
            customNavigationItemView: customNavigationItemView,
            leftImageView: leftImageView,
            navigationTitleLabel: navigationTitleLabel,
            rightImageView: rightImageView
        )
        bindVM()
    }
    
    func bindVM() {
        let input = HomeEmptyViewModel.Input(
            presentWorkSpaceList: customNavigationItemView.rx.tap
        )
        
        let output = viewModel.transform(input)
    }
    
   
}
