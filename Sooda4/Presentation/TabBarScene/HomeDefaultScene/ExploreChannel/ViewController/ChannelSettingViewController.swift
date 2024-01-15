//
//  ChannelSettingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit

class ChannelSettingViewController: BaseViewController {
    
    
    lazy var collectionView = { [self] in
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "hi")
        
        view.backgroundColor = .red
        
        return view
    }()
    
    let arrayCnt = 20
    
    func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 50, height: 50)
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        
        return layout
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func setting() {
        super.setting()
        
        view.addSubview(collectionView)
        
        let heightCnt = arrayCnt / 6 + (arrayCnt % 6 == 0 ? 0 : 1)
        
        print(heightCnt)
        
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(heightCnt * 50)
//            make.height.greaterThanOrEqualTo(100)
//            make.height.equalTo(100)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
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
