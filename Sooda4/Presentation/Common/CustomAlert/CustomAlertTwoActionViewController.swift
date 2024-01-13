//
//  CustomAlertTwoActionViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import UIKit

class CustomAlertTwoActionViewController: BaseViewController {
    
    convenience init(
        title: String,
        message: String,
        okButtonTitle: String,
        okCompletion: @escaping () -> Void,
        cancelButtonTitle: String,
        cancelCompletion: @escaping () -> Void
    ) {
        self.init()
        
        self.okCompletion = okCompletion
        self.cancelCompletion = cancelCompletion
        
        titleLabel.text = title
        titleLabel.setAppFont(.title2)
        titleLabel.textAlignment = .center
        
        messageLabel.text = message
        messageLabel.setAppFont(.body)
        messageLabel.textAlignment = .center
        
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setAppFont(.title2, for: .normal)
        
        okButton.setTitle(okButtonTitle, for: .normal)
        okButton.setAppFont(.title2, for: .normal)
        
        modalPresentationStyle = .overFullScreen
    }
    
    var okCompletion: ( () -> Void )?
    var cancelCompletion: ( () -> Void )?
    
    @objc func okButtonClicked() { okCompletion?() }
    @objc func cancelButtonClicked() { cancelCompletion?() }
    
    
    
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
        let view = SignUpActiveButton("확인") // 타이틀 바꿀 예정
        view.update(.enabled)
        view.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
        return view
    }()
    
    lazy var cancelButton = {
        let view = SignUpActiveButton("취소") // 타이틀 바꿀 예정
//        view.update(.disabled)    // 이걸로 해두면 클릭 자체가 불가능
        view.update(.enabled)
        view.backgroundColor = UIColor.appColor(.brand_inactive)
        view.addTarget(self , action: #selector(cancelButtonClicked), for: .touchUpInside)
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
        [titleLabel, messageLabel, okButton, cancelButton].forEach { item in
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
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.trailing.equalTo(backView.snp.centerX).offset(-4)
            make.leading.bottom.equalTo(backView).inset(16)
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
        }
        
        okButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.equalTo(backView.snp.centerX).offset(4)
            make.trailing.bottom.equalTo(backView).inset(16)
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
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
