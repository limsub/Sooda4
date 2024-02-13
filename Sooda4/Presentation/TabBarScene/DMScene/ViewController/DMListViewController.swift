//
//  DMListViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 2/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct DMListSectionData {
    // 어차피 섹션 하나밖에 없음
    
    var header: String
    var items: [Item]
}

extension DMListSectionData: AnimatableSectionModelType {
    typealias Item = DMChattingCellInfoModel
    typealias Identity = String
    
    var identity: String {
        return header
    }
    
    init(original: DMListSectionData, items: [DMChattingCellInfoModel]) {
        self = original
        self.items = items
    }
}

struct DMChattingCellInfoModel {
    let roomId: Int
    let userInfo: UserInfoModel
    let lastContent: String
    let lastDate: Date
    let unreadCount: Int
}

extension DMChattingCellInfoModel: IdentifiableType, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        return roomId
    }
}

class DMListViewController: BaseViewController {
    
    let mainView = DMListView()
    let viewModel = DMListViewModel(workSpaceId: 265)
    
    
    private var disposeBag = DisposeBag()
    
    let loadData = PublishSubject<Void>()
    
    
    // Navigation 영역
    let customNavigationItemView = UIButton()
    let leftImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "profile_No Photo A")
        return view
    }()
    let navigationTitleLabel = {
        let view = UILabel()
        view.text = "Direct Message"
        view.setAppFont(.title1)
        return view
    }()
    let rightImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.image = UIImage(named: "profile_No Photo B")
        view.layer.borderColor = UIColor(hexCode: "#323538").cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        
        setNavigation()
        bindVM()
        
        self.loadData.onNext(())
    }
    
    /* === setting === */
    func setNavigation() {
        setCustomNavigation(
            customNavigationItemView: customNavigationItemView,
            leftImageView: leftImageView,
            navigationTitleLabel: navigationTitleLabel,
            rightImageView: rightImageView
        )
    }

    
    
    /* === bind === */
    func bindVM() {
        let input = DMListViewModel.Input(
            loadData: self.loadData,
            
            testButtonClicked: mainView.testButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        
        // Navigation
        output.workSpaceImage
            .subscribe(with: self) { owner , url in
                owner.leftImageView.loadImage(
                    endURLString: url,
                    size: CGSize(width: 40, height: 40),
                    placeholder: .profileNoPhotoA
                )
            }
            .disposed(by: disposeBag)
        
        output.profileImage
            .subscribe(with: self) { owner , url in
                owner.rightImageView.loadImage(
                    endURLString: url,
                    size: CGSize(width: 40, height: 40),
                    placeholder: .profileNoPhotoA
                )
            }
            .disposed(by: disposeBag)
        
        
        // HeaderViewCollectionView
        output.workSpaceMemberList
            .bind(to: mainView.headerView.memberListCollectionView.rx.items(cellIdentifier: ChannelSettingMemberCollectionViewCell.description(), cellType: ChannelSettingMemberCollectionViewCell.self)) { (row, element, cell) in
                
                cell.designCell(
                    imageUrl: element.profileImage,
                    name: element.nickname
                )
                
            }
            .disposed(by: disposeBag)
        
        
        // DMListTableView - RxDataSource
        let dataSource = RxTableViewSectionedAnimatedDataSource<DMListSectionData>(
            animationConfiguration: AnimationConfiguration(
                insertAnimation: .fade,
                reloadAnimation: .fade,
                deleteAnimation: .fade
            )
        ) { data, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DMListTableViewCell.description(), for: indexPath) as? DMListTableViewCell else { return UITableViewCell() }
            
            cell.designCell(item)
            
            return cell
        }
        
        output.dmRoomSectionsArr
            .bind(to: mainView.dmListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        

        
        

    }
}

/*
// CollectionView
extension DMListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelSettingMemberCollectionViewCell.description(), for: indexPath) as? ChannelSettingMemberCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
*/
