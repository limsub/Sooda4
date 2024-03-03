//
//  PurchaseCoinButton.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import UIKit
import SnapKit

class PurchaseCoinButton: UIButton {
    
    let coinImageView = {
        let view = UIImageView()
        view.image = .sample1
        return view
    }()
    
    let coinAmountLabel = {
        let view = UILabel()
        view.text = "100"
        return view
    }()
    
    let coinPriceLabel = {
        let view = UILabel()
        view.text = "200원"
        view.backgroundColor = UIColor.appColor(.brand_green)
        return view
    }()
    
    
    convenience init(coinType: CoinType) {
        self.init()
        
        setUp(coinType: coinType)
        setting()
    }
    
    func setting() {
        
        [coinImageView, coinAmountLabel, coinPriceLabel].forEach {
            self.addSubview($0)
        }
        
        coinImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(8)
            make.size.equalTo(54)
        }
        
        coinPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(8)
            make.width.equalTo(74)
            make.height.equalTo(30)
        }
        
        coinAmountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(coinImageView.snp.trailing).offset(8)
        }
    }
    
    func setUp(coinType: CoinType) {
        
        coinImageView.image = coinType.image
        
        coinAmountLabel.text = coinType.title
        
        coinPriceLabel.text = coinType.price
        
        
        coinAmountLabel.setAppFont(.bodyBold)
        coinPriceLabel.setAppFont(.title2)
        
        coinPriceLabel.textAlignment = .center
        
    }
    
    
    enum CoinType {
        case a  // 10 coin
        case b  // 50 coin
        case c  // 100 coin
        
        var title: String {
            switch self {
            case .a:
                return "10 coin"
            case .b:
                return "50 coin"
            case .c:
                return "100 coin"
            }
        }
        
        var price: String {
            switch self {
            case .a:
                return "₩100"
            case .b:
                return "₩500"
            case .c:
                return "₩1,000"
            }
        }
        
        var image: UIImage {
            switch self {
            case .a:
                return .coinA
            case .b:
                return .coinB
            case .c:
                return .coinC
            }
        }
    }
}
