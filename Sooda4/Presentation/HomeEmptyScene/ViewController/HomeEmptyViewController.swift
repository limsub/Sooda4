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
        view.text = "iOS Developers Study"
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

       
        setNavigation()
        bindVM()
    }
    
    func setNavigation() {
        
        guard let navigationBar = navigationController?.navigationBar else {
            print("qqqqqq")
            return
        }
        
        print(#function)
        print(navigationController)
        
        let navHeight = navigationBar.frame.size.height
        let navWidth = navigationBar.frame.size.width
        
        customNavigationItemView.backgroundColor = .white
        
        customNavigationItemView.addSubview(leftImageView)
        customNavigationItemView.addSubview(navigationTitleLabel)
        customNavigationItemView.addSubview(rightImageView)
        
        customNavigationItemView.snp.makeConstraints { make in
            make.width.equalTo(navWidth)
            make.height.equalTo(navHeight)
        }
        
        
        leftImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        navigationTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(8)
            make.trailing.equalTo(rightImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        let leftBarBtn = UIBarButtonItem(customView: customNavigationItemView)
        navigationItem.leftBarButtonItem = leftBarBtn
 
        
        //
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
//        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
    
    func bindVM() {
        let input = HomeEmptyViewModel.Input(
            presentWorkSpaceList: customNavigationItemView.rx.tap
        )
        
        let output = viewModel.transform(input)
    }
    
   
}
