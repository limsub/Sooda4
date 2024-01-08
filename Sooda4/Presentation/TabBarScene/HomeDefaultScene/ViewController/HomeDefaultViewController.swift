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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
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
