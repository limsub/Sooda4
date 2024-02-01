//
//  DMListTableViewHeaderView.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import UIKit

final class DMListTableViewHeaderView: BaseView {
    
    
    lazy var memberListCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createMemberCollectionViewLayout())
        
        view.register(ChannelSettingMemberCollectionViewCell.self, forCellWithReuseIdentifier: ChannelSettingMemberCollectionViewCell.description())
        
        view.showsHorizontalScrollIndicator = false
            
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(memberListCollectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        memberListCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
}

extension DMListTableViewHeaderView {
    private func createMemberCollectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 30, left: 8, bottom: 0, right: 8)
        
        layout.itemSize = CGSize(width: 76, height: 91)
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
}
