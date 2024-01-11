//
//  HomeDefaultViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit
import SnapKit
import SideMenu

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class HomeDefaultViewController: BaseViewController {
    
    var viewModel: HomeDefaultViewModel!
    
    static func create(with viewModel: HomeDefaultViewModel) -> HomeDefaultViewController {
        let vc = HomeDefaultViewController()
        vc.viewModel = viewModel
        return vc
    }

    
    
    let mainView = HomeDefaultView()
    
    
    // Navigation 영역의 객체들
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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        
        
        fetchFirstData()
        
        
        setNavigation()
        setTableView()
 
        bindVM()
    }
    
    func setNavigation() {
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        let navHeight = navigationBar.frame.size.height
        let navWidth = navigationBar.frame.size.width
        
        let customNavigationItemView = UIView()
        customNavigationItemView.backgroundColor = .white
        
        customNavigationItemView.addSubview(leftImageView)
        customNavigationItemView.addSubview(navigationTitleLabel)
        customNavigationItemView.addSubview(rightImageView)
        
        customNavigationItemView.snp.makeConstraints { make in
            make.width.equalTo(navWidth)
            make.height.equalTo(navHeight)
        }
        
        
        leftImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        navigationTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(8)
            make.trailing.equalTo(rightImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        let leftBarBtn = UIBarButtonItem(customView: customNavigationItemView)
        navigationItem.leftBarButtonItem = leftBarBtn
        
        
        //
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
//        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
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
    
    let testButton = UIButton()
    
    func bindVM() {
        testButton.backgroundColor = .red
        view.addSubview(testButton)
        testButton.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        
        
        let input = HomeDefaultViewModel.Input(
            presentWorkSpaceList: testButton.rx.tap
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
        
        // 1. 접었다 폈다
        viewModel.toggleOpenedData(indexPath) {
            tableView.reloadSections([indexPath.section], with: .none)
        }
        
        
        
        // 2. 맨 아래 클릭 -> 추가 (section 0, 1, 2)
    
        
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
