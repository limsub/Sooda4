//
//  UIImageView+LoadImage.swift
//  Sooda4
//
//  Created by 임승섭 on 1/24/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(endURLString: String, size: CGSize, placeholder: UIImage) {
        
        let imageURLString = APIKey.baseURL + "/" + endURLString
        let imageURL = URL(string: imageURLString)
//        print("00000")
//        print(imageURLString)
//        print("00000")
        let header = [
            "Authorization": KeychainStorage.shared.accessToken ?? "",
            "SesacKey": APIKey.key
        ]
        
        let modifier = AnyModifier { request in
            var modifiedRequest = request
            for (key, value) in header {
                modifiedRequest.headers.add(name: key, value: value)
            }
            return modifiedRequest
        }
        
        let processor = DownsamplingImageProcessor(size: size)
        
        self.kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: [
                .requestModifier(modifier),
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}
