//
//  UIViewController+Navigation.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit


extension UIViewController {
    func setNavigation(_ title: String) {
        navigationItem.title = title
        if let sheetPresentationController {
            sheetPresentationController.prefersGrabberVisible = true
        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
//        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
    
    func setCustomNavigation(
        customNavigationItemView: UIButton,
        leftImageView: UIImageView,
        navigationTitleLabel: UILabel,
        rightImageView: UIImageView
    ) {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }

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
    
    
    // WorkSpaceListView 처럼 나오는 곳. 실제 라지타이틀은 아니고, 레이블을 넣어줌
    func setLargeTitleNavigation(_ title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.setAppFont(.title1)
        
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.appColor(.background_primary)
//        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
    
}
