//
//  HomeDefaultViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import UIKit
import SnapKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class HomeDefaultViewController: BaseViewController {
    
    // 섹션 1 : 채널
    // 섹션 2 : 디엠
    // 섹션 3 : 팀원 추가
    
    
    var channelData = cellData(
        opened: true,
        title: "채널",
        sectionData: ["일반", "스유 뽀개기", "앱스토어 홍보", "오픈라운지", "TIL"]
    )
    var dmData = cellData(
        opened: true,
        title: "다이렉트 메세지 - 3개",
        sectionData: ["캠퍼스지킴이", "Hue", "테스트 코드 짜는 새싹이", "Jack"]
    )
    
    
    
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
        
        setNavigation()
        setTableView()
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
}

extension HomeDefaultViewController: UITableViewDelegate, UITableViewDataSource {

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(section)
        switch section {
        case 0:
            // 섹션 들어가는거 하나 빼고,
            // 근데 마지막에 추가하기 때문에 하나 추가하고
            // -> 쌤
//            return channelData.sectionData.count + 2
            
            if channelData.opened {
                return channelData.sectionData.count + 2
            } else {
                return 1
            }
        case 1:
            if dmData.opened {
                return dmData.sectionData.count + 2
            } else {
                return 1
            }
            
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        print(indexPath)
        
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0), (1, 0):
            // 1. 섹션 접었다 폈다
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDefaultSectionTableViewCell.description(), for: indexPath) as? HomeDefaultSectionTableViewCell else { return UITableViewCell() }
            
            // (1). 채널 섹션
            if indexPath.section == 0 {
                cell.designCell("채널", isOpend: channelData.opened)
            }
            // (2). 디엠 섹션
            else {
                cell.designCell("다이렉트 메세지", isOpend: dmData.opened)
            }
            
            cell.hideSeparator()
            return cell
            // return 하니까 다음 케이스로 안넘어갈거야
            
        case (0, channelData.sectionData.count + 1), (1, dmData.sectionData.count + 1), (2, 0):
            // 4. 추가하기
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDefaultPlusTableViewCell.description(), for: indexPath) as? HomeDefaultPlusTableViewCell else { return UITableViewCell() }
            
            // (1). 채널 섹션
            if indexPath.section == 0 {
                cell.designCell("채널 추가")
            }
            // (2). 디엠 섹션
            else if indexPath.section == 1 {
                cell.designCell("새 매시지 시작")
            }
            // (3). 팀원 추가
            else {
                cell.designCell("팀원 추가")
            }
            
            
            
            return cell
            
            
        case (0, _):
            // 2. 채널 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDefaultChannelTableViewCell.description(), for: indexPath) as? HomeDefaultChannelTableViewCell else { return UITableViewCell() }
            
            cell.designCell(channelData.sectionData[indexPath.row - 1], count: Int.random(in: 1...100))
            
            
            cell.hideSeparator()
            return cell
            
            
        case (1, _):
            // 3. 디엠 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDefaultDMTableViewCell.description(), for: indexPath) as? HomeDefaultDMTableViewCell else { return UITableViewCell() }
            
            cell.designCell(dmData.sectionData[indexPath.row - 1], count: Int.random(in: 10000...9999999))
            
            cell.hideSeparator()
            return cell
            
            
        default:
            return UITableViewCell()
        }
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0), (1, 0):
            // 1. 섹션 접었다 폈다
            return 56

            
        case (0, channelData.sectionData.count - 1), (1, dmData.sectionData.count - 1), (2, 0):
            // 4. 추가하기
            return 41


            
        case (0, _):
            // 2. 채널 셀
            return 44

            
        case (1, _):
            // 3. 디엠 셀
            return 44

            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 맨 위 클릭 -> 접었다 폈다 (단, section 0, 1)
        if indexPath.section == 0 && indexPath.row == 0 {
            channelData.opened = !channelData.opened
            
            if let cell = tableView.cellForRow(at: indexPath) as? HomeDefaultSectionTableViewCell {
                
                
//                // 접 -> 폇
//                if channelData.opened {
//                    UIView.animate(withDuration: 0.2) {
//                        cell.chevronImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
//                    }
//                }
//                
//                // 폇 -> 접
//                else {
//                    UIView.animate(withDuration: 0.2) {
//                        cell.chevronImageView.transform = CGAffineTransform(rotationAngle: 0)
//                    }
//                }
                
                
                
                tableView.reloadSections([0], with: .none)
            }
            
          
            
            
//            tableView.reloadSections([0], with: .none)
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            dmData.opened = !dmData.opened
            tableView.reloadSections([1], with: .none)
        }
        
        
        // 맨 아래 클릭 -> 추가 (section 0, 1, 2)
        
        
        
        
    }
    
    
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
