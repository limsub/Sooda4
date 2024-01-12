//
//  CustomAlertOneActionViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import UIKit


class CustomAlertOneActionViewController: BaseViewController {
    
    convenience init(title: String, message: String, completion: @escaping () -> Void) {
        self.init()
        
        self.completion = completion
        titleLabel.text = title
        titleLabel.setAppFont(.title2)
        titleLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.setAppFont(.body)
        messageLabel.textAlignment = .center
        
        modalPresentationStyle = .overFullScreen
    }
   
    var completion: ( () -> Void )?
    @objc
    func okButtonClicked() {
        completion?()
    }
    
    func setUp(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
        
    }
    
    let backView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(.brand_white)
        view.layer.cornerRadius = 16
        
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    lazy var titleLabel = {
        let view = UILabel()
        view.textColor = UIColor.appColor(.text_primary)
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()
    
    lazy var messageLabel = {
        let view = UILabel()
        view.textColor = UIColor.appColor(.text_secondary)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var okButton = {
        let view = SignUpActiveButton("확인")
        view.update(.enabled)
        view.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
        return view
    }()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut) {
            self.backView.transform = .identity
            self.backView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut) {
            self.backView.transform = .identity
            self.backView.isHidden = true
        }
    }
    
    
    override func setConfigure() {
        super.setConfigure()
        
        
        view.addSubview(backView)
        [titleLabel, messageLabel, okButton].forEach { item in
            backView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.horizontalEdges.equalTo(view).inset(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(backView).inset(16)
            make.horizontalEdges.equalTo(backView).inset(16.5)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(backView).inset(16.5)
        }
        
        okButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(backView).inset(16)
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.height.equalTo(44)
            
        }
        
        
    }
    
    override func setting() {
        super.setting()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        setTapGesture()
    }
    
    
    func setTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func didTapView() {
        print(#function)
        self.dismiss(animated: false)
    }
}
