//
//  HomeEmptyViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit

class HomeEmptyViewController: BaseViewController {
    
    let mainView = HomeEmptyView()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        mainView.b1.addTarget(self , action: #selector(b1Clicked), for: .touchUpInside)
    }
    
    var k: ( () -> Void )?
    
    @objc
    func b1Clicked() {
        
        k?()
        
    }
}
