//
//  ChannelSettingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

class ChannelSettingViewController: BaseViewController {
    
    
    lazy var collectionView = { [self] in
        let view = UICollectionView(frame: .zero, collectionViewLayout: configurePinterestLayout())
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "hi")
        
        view.backgroundColor = .red
        
        return view
    }()
    
    let arrayCnt = 20
    
    func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 50, height: 50)
        
        
        return layout
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func setting() {
        super.setting()
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//            make.height.greaterThanOrEqualTo(100)
//            make.height.equalTo(100)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    
    
    // 9/26
    func configurePinterestLayout() -> UICollectionViewLayout {
    
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(150))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        
        // 다른 함수 사용
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSIze,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(10)
            
        // section: 그룹을 감싼다
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 10
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        

        return layout
    }
}

extension ChannelSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayCnt
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hi", for: indexPath)
        
        cell.backgroundColor = .gray
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        // 한 줄에 6개 들어간다고 치고, 셀 하나당 높이 50이라면,
        let height = arrayCnt / 6 + (arrayCnt % 6 == 0 ? 0 : 1)
        
        return CGSize(
            width: collectionView.bounds.width,
            height: CGFloat(height)
        )
        
    }
    
}
