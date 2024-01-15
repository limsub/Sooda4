//
//  ChannelSettingMembersTableViewCell.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

// width : screen 동일.
// height -> .automaticDimension 안잡힐 것 같음.
// 직접 멤버 카운트와 셀 높이 계산해서 지정해주는 게 더 나을 것 같음
class ChannelSettingMembersTableViewCell: BaseTableViewCell {
    
    // 컬렉션뷰에 띄울 데이터를 가지고 있어야 한다..
    let items = ["james", "jordan", "hiHI", "james", "jordan", "hiHI", "james", "jordan", "hiHI", "james", "jordan", "hiHI", "james", "jordan", "hiHI", "james", "jordan", "hiHI", "james", "jordan", "hiHI"]
    
    // 좌우 여백 6. 높이 cell과 동일
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createMemberCollectionViewLayout())
        
        view.register(ChannelSettingMemberCollectionViewCell.self, forCellWithReuseIdentifier: ChannelSettingMemberCollectionViewCell.description())
        
        view.isScrollEnabled = false
        
        view.dataSource = self
        
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(collectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(6)
            make.height.equalTo(contentView)
        }
    }
    
    
    // 외부에서 접근
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
}


extension ChannelSettingMembersTableViewCell {
    func createMemberCollectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 76, height: 91)
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
}


extension ChannelSettingMembersTableViewCell: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelSettingMemberCollectionViewCell.description(), for: indexPath) as? ChannelSettingMemberCollectionViewCell else { return UICollectionViewCell() }
        
        print(#function)
        
        cell.nameLabel.text = items[indexPath.row]
        
        return cell
    }
    

}
