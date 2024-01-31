//
//  ChannelChattingInputFileImageCollectionViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class ChannelChattingInputFileImageCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let fileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "profile_SesacBot")
        return view
    }()
    
    let cancelButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "icon_cancel"), for: .normal)
        return view
    }()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        [fileImageView, cancelButton].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        fileImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.bottom.equalTo(contentView)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.trailing.equalTo(contentView)
        }
    }
    
    func designCell(_ data: FileDataModel) {
        
        if data.fileExtension == .jpeg {
            fileImageView.image = UIImage(data: data.data)
        } else {
            fileImageView.image = UIImage(named: data.fileExtension.imageName)
        }
    }
    
}
