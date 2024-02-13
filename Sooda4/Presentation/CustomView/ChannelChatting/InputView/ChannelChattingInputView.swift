//
//  ChannelChattingInputView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/18/24.
//

import UIKit

class ChannelChattingInputView: BaseView {
    
    let plusButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "icon_plus"), for: .normal)
        return view
    }()
    
    let sendButton = {
        let view = ChannelChattingSendButton()
        view.update(.disabled)
        return view
    }()
    
    let chattingTextView = {
        let view = ChannelChattingTextView()
        // 3줄까지는 늘어나게 하기 위해 스크롤 불가
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var fileImageCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createFileImageCollectionViewLayout())
        
        view.register(ChannelChattingInputFileImageCollectionViewCell.self, forCellWithReuseIdentifier: ChannelChattingInputFileImageCollectionViewCell.description())
        
        view.backgroundColor = UIColor.appColor(.background_primary)
        
        return view
    }()
    
    func createFileImageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        
        return layout
    }

    
    override func setConfigure() {
        super.setConfigure()
        
        [plusButton, sendButton, chattingTextView, fileImageCollectionView].forEach { item  in
            self.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        self.removeConstraints(self.constraints)
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.leading.equalTo(self).inset(12)
            make.bottom.equalTo(self).inset(8)
        }
        
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalTo(self).inset(12)
            make.bottom.equalTo(self).inset(8)
        }
        
    [
        chattingTextView.topAnchor.constraint(
            equalTo: self.topAnchor, constant: 3.2
        ),
        chattingTextView.leadingAnchor.constraint(
            equalTo: plusButton.trailingAnchor, constant: 8
        ),
        chattingTextView.trailingAnchor.constraint(
            equalTo: sendButton.leadingAnchor, constant: -8
        ),
        chattingTextView.heightAnchor.constraint(equalToConstant: 31.6),
    
    ].forEach{ $0.isActive = true }
    
    
    chattingTextView.bottomAnchor.constraint(
        equalTo: self.bottomAnchor, constant: -3.2
    ).isActive = fileImageCollectionView.isHidden
        
        
        fileImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chattingTextView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(chattingTextView)
            make.height.equalTo(50)
            make.bottom.equalTo(self).inset(8)
        }
    }
    
    
    override func setting() {
        super.setting()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.appColor(.background_primary)

//        fileImageCollectionView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.chattingTextView.resignFirstResponder()
    }
}

