//
//  PurchaseCoinButton.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import UIKit
import SnapKit

class PurchaseCoinButton: UIButton {
    
    let coinImage = {
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
        return view
    }()
    
    
    convenience init() {
        self.init()
        
        setting()
    }
    
    func setting() {
        
        [coinImage, coinAmountLabel, coinPriceLabel].forEach {
            self.addSubview($0)
        }
        
        coinImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(8)
            make.size.equalTo(40)
        }
        
        coinAmountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(coinImage.snp.trailing).offset(8)
            make.size.equalTo(50)
        }
        
        coinPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(coinAmountLabel.snp.trailing).offset(8)
            make.size.equalTo(50)
        }
    }
    
    func setUp() {
        
    }
    
    
    enum CointType {
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
