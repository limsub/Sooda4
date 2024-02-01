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
    
    var items: [UserInfoModel] = []
    
    
    // 좌우 여백 6. 높이 cell과 동일
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createMemberCollectionViewLayout())
        
        view.register(ChannelSettingMemberCollectionViewCell.self, forCellWithReuseIdentifier: ChannelSettingMemberCollectionViewCell.description())
        
        view.isScrollEnabled = false
        
        view.dataSource = self

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
    
    override func setting() {
        super.setting()
        
        self.collectionView.heightAnchor.constraint(equalToConstant: 900).isActive = true
    }
    
    // 외부에서 접근
    func reloadCollectionView() {
        self.collectionView.reloadData()
        setCollectionViewHeight()
    }
}


extension ChannelSettingMembersTableViewCell {
    private func createMemberCollectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 76, height: 91)
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
    
    func setCollectionViewHeight() {
        
        // 셀 하나당 높이 91.
        // 맨 위 셀과 맨 아래 셀 기준 컬렉션뷰 자체에 패딩 0
        // 한 줄에 셀 5개 기준
        
        
        let itemCnt = items.count
        let lineCnt = itemCnt / 5 + (itemCnt % 5 == 0 ? 0 : 1)
        let height: CGFloat = CGFloat(lineCnt * 91)
        
        print("===========\(itemCnt)================")
        print("===========\(height)================")
        
        self.collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
}


extension ChannelSettingMembersTableViewCell: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelSettingMemberCollectionViewCell.description(), for: indexPath) as? ChannelSettingMemberCollectionViewCell else { return UICollectionViewCell() }
        
        let data = items[indexPath.row]
        
        cell.designCell(
            imageUrl: data.profileImage,
            name: data.nickname
        )
        
        return cell
    }
    

}
