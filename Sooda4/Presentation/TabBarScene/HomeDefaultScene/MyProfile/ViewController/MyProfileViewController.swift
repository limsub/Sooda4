//
//  MyProfileViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import iamport_ios
import WebKit

class MyProfileViewController: BaseViewController {
    
    private let mainView = MyProfileView()
    private var viewModel: MyProfileViewModel!
    
    // 결제 웹뷰
    private lazy var wkWebView = {
        let view = WKWebView(frame: mainView.frame)
        view.backgroundColor = .clear
        return view
    }()
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: MyProfileViewModel) -> MyProfileViewController {
        
        let vc = MyProfileViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    // 초기 데이터 로드
    private let loadData = PublishSubject<Void>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVM()
        fetchFirstData()
        setButtonTarget()
    }
    
    private func bindVM() {
        let input = MyProfileViewModel.Input(
            loadData: self.loadData
        )
        
        let output = viewModel.transform(input)
    }
    
    private func fetchFirstData() {
        self.loadData.onNext(())
    }
}


// 결제 버튼 클릭
extension MyProfileViewController {
    
    private func setButtonTarget() {
        mainView.aCoinButton.addTarget(self , action: #selector(aCoinButtonClicked), for: .touchUpInside)
        mainView.bCoinButton.addTarget(self , action: #selector(bCoinButtonClicked), for: .touchUpInside)
        mainView.cCoinButton.addTarget(self , action: #selector(cCoinButtonClicked), for: .touchUpInside)
    }
    
    // a
    @objc func aCoinButtonClicked() {
        
        setWebView()
        
        
        let pg = PG.html5_inicis.makePgRawName(pgId: "INIpayTest")
        
        let merchant_uid = "ios_\(APIKey.key)_\(Int(Date().timeIntervalSince1970))"
                
        let payment = IamportPayment(
            pg: pg,
            merchant_uid: merchant_uid,
            amount: "100"
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = "10 Coin"
            $0.buyer_name = "임승섭"
            $0.app_scheme = "sesac"
        }
        
        
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: APIKey.portUserCode,
            payment: payment) { [weak self] response in
                
                print("***")
                
                print(String(describing: response))
                
                print("***")
                
                print(response?.imp_uid)
                
                print("***")
                
                print(response?.merchant_uid)
                
                print("***")
            }
    }
    
    // b
    @objc func bCoinButtonClicked() {
        
    }
    
    
    // c
    @objc func cCoinButtonClicked() {
        
    }
}


// webView
extension MyProfileViewController {
    private func setWebView() {
        mainView.addSubview(wkWebView)
            
        wkWebView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(mainView.safeAreaLayoutGuide)
            make.bottom.equalTo(mainView)
        }
    }

    private func removeWebView() {
        mainView.willRemoveSubview(wkWebView)
        wkWebView.stopLoading()
        wkWebView.removeFromSuperview()
    }
}
