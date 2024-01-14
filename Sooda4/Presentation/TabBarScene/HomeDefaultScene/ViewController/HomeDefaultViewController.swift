//
//  HomeDefaultViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit
import SnapKit
import SideMenu
import RxSwift
import RxCocoa

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class HomeDefaultViewController: BaseViewController {
    
    let mainView = HomeDefaultView()
    var viewModel: HomeDefaultViewModel!
    
    let disposeBag = DisposeBag()
    
    static func create(with viewModel: HomeDefaultViewModel) -> HomeDefaultViewController {
        let vc = HomeDefaultViewController()
        vc.viewModel = viewModel
        
        return vc
    }

    // Action Sheet의 버튼 클릭 이벤트를 Input으로 전달하기 위함. 한 번 거쳤다 가는 느낌으로 이해하기
    let makeChannelEvent = PublishSubject<Void>()
    let exploreCannelEvent = PublishSubject<Void>()
    
    
    
    
    // Navigation 영역의 객체들
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
        view.text = "iOS Developers Study"
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
    
    
    
    // side menu present할 때 HomeDefault 블러처리 하기 위함 -> 실패
    let aView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(.brand_black).withAlphaComponent(0.5)
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        fetchFirstData()
    
        setCustomNavigation(
            customNavigationItemView: customNavigationItemView,
            leftImageView: leftImageView,
            navigationTitleLabel: navigationTitleLabel,
            rightImageView: rightImageView
        )
        setTableView()
 
        bindVM()
        
//        addBlurView()
        showBlurView(false)
        
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }

//    func addBlurView() {
//        UIApplication.shared.keyWindow!.bringSubviewToFront(aView)
////        if let window = UIApplication.shared.windows.first {
////            window.addSubview(aView)
////            aView.snp.makeConstraints { make in
////                make.edges.equalTo(window)
////            }
////        }
//    }
    
    func showBlurView(_ show: Bool) {
        aView.isHidden = !show
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func fetchFirstData() {
        viewModel.fetchFirstData {
            self.mainView.tableView.reloadData()
            self.updateNavigationView()
        }
    }
    
    func updateNavigationView() {
        navigationTitleLabel.text = viewModel.workSpaceInfo?.name
//        leftImageView.image = viewModel.workSpaceInfo?.thumbnail
//        rightImageView.image = viewModel.myProfileInfo?.profileImage
        
    }
    

    func bindVM() {
        let input = HomeDefaultViewModel.Input(
            presentWorkSpaceList: customNavigationItemView.rx.tap,
            tableViewItemSelected: mainView.tableView.rx.itemSelected,
            presentMakeChannel: makeChannelEvent,
            presentExploreChannel: exploreCannelEvent
        )
        
        let output = viewModel.transform(input)
        
        
        
    }
    

}

extension HomeDefaultViewController: UITableViewDelegate, UITableViewDataSource {

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellType = viewModel.checkCellType(indexPath: indexPath)
        
        switch cellType {
        case .foldingCell:  // 1. 접었다 폈다 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDefaultSectionTableViewCell.description(), for: indexPath) as? HomeDefaultSectionTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.foldingCellData(indexPath)
            
            cell.designCell(data.0, isOpend: data.1)
            
            cell.hideSeparator()
            return cell
            
        case .channelCell:  // 2. 채널 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDefaultChannelTableViewCell.description(), for: indexPath) as? HomeDefaultChannelTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.channelCellData(indexPath)
            
            cell.designCell(data.0, count: data.1)
            
            
            
            
            
            cell.hideSeparator()
            return cell
            
        case .dmCell:       // 3. 디엠 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDefaultDMTableViewCell.description(), for: indexPath) as? HomeDefaultDMTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.dmCellData(indexPath)
            
            cell.designCell(
                image: data.0,
                text: data.1,
                count: data.2
            )
            
            cell.hideSeparator()
            return cell
                
        case .plusCell:     // 4. 추가 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDefaultPlusTableViewCell.description(), for: indexPath) as? HomeDefaultPlusTableViewCell else { return UITableViewCell() }
            
            if indexPath.section == 0 {
                cell.designCell("채널 추가")
            } else if indexPath.section == 1 {
                cell.designCell("새 매시지 시작")
            } else {
                cell.designCell("팀원 추가")
            }
            
            return cell
        }
 

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellType = viewModel.checkCellType(indexPath: indexPath)
        
        switch cellType {
        case .foldingCell:
            return 56
        case .channelCell, .dmCell:
            return 44
        case .plusCell:
            return 41
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 1. 접었다 폈다 (-> 단순 테이블뷰 리로드)
        viewModel.toggleOpenedData(indexPath) {
            tableView.reloadSections([indexPath.section], with: .none)
        }
        
        
        
        // 2. 맨 아래 클릭 -> 추가 (section 0, 1, 2)
        // 2 - 1. 채널 추가 -> Action Sheet -> 여기서 선택 시 VM으로 전달 후 -> 코디로 전달
        if indexPath.section == 0
        && viewModel.checkCellType(indexPath: indexPath) == .plusCell {
            showActionSheetTwoSection(firstTitle: "채널 생성", firstCompletion: {
                self.makeChannelEvent.onNext(())
            }, secondTitle: "채널 탐색") {
                self.exploreCannelEvent.onNext(())
            }
        }
        
        // 2 - 3. 팀원 추가 -> 새로운 뷰 present -> 코디로 전달할 필요 -> VM에서 전달. -> rx Input / Output 구현
    
        
    }
    
    
}

enum HomeDefaultTableViewCellType {
    case foldingCell
    case channelCell
    case dmCell
    case plusCell
}

// 테이블뷰 셀 종류
// 1. (height 56) 섹션 접었다 폈다 (왼쪽 텍스트 - 오른쪽 chevron)
// 2. (height 41) 채널 섹션의 셀 (왼쪽 # - 가운데 텍스트 - 오른쪽 초록색 배경 숫자)
// 3. (height 44) DM 섹션의 셀 (왼쪽 이미지 - 가운데 텍스트 - 오른족 초록색 배경 숫자)
// 4. (height 41) 추가 셀 (왼쪽 + - 가운데 텍스트)

// 커스텀 뷰로 만들 것
// - 왼쪽 #
// - 가운데 텍스트
// - 오른쪽 초록색 배경 숫자















class sample2VC: BaseViewController {
    let l = UILabel()
    override func setting() {
        super.setting()
        
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        l.text = "디엠"
        l.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
    }
}

class sample3VC: BaseViewController {
    let l = UILabel()
    override func setting() {
        super.setting()
        
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        l.text = "검색"
        l.backgroundColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }
}

class sample4VC: BaseViewController {
    let l = UILabel()
    override func setting() {
        super.setting()
        
        view.addSubview(l)
        l.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        l.text = "설정"
        l.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
}
