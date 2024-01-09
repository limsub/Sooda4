//
//  HomeDefaultViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit
import SnapKit

class HomeDefaultViewController: BaseViewController {
    
    let l = UILabel()
    override func setting() {
        super.setting()
        
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        l.text = "홈 디폴트"
        l.backgroundColor = .white
    }
    
    // Navigation 영역의 객체들
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        
        setNavigation()
    }
    
    func setNavigation() {
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        let navHeight = navigationBar.frame.size.height
        let navWidth = navigationBar.frame.size.width
        
        let customNavigationItemView = UIView()
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
}

















class sample2VC: BaseViewController {
    let l = UILabel()
    override func setting() {
        super.setting()
        
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        l.text = "디엠"
        l.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
    }
}

class sample3VC: BaseViewController {
    let l = UILabel()
    override func setting() {
        super.setting()
        
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        l.text = "검색"
        l.backgroundColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }
}

class sample4VC: BaseViewController {
    let l = UILabel()
    override func setting() {
        super.setting()
        
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        l.text = "설정"
        l.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
}
