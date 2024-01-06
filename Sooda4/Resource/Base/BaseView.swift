//
//  BaseView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setConstraints()
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure() { }
    func setConstraints() { }
    func setting() { 
        self.backgroundColor = UIColor.appColor(.background_primary)
    }
}
