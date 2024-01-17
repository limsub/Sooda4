//
//  ChangeAdminChannelViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/17/24.
//

import UIKit
import RxSwift
import RxCocoa

// 워크스페이스 관리자 권한 변경 -> rx 안쓰고 delegate로 처리
// 채널 관리자 권한 변경 -> rx 사용

class ChangeAdminChannelViewController: BaseViewController {
    
    private var viewModel: ChangeAdminChannelViewModel!
    private let mainView = ChangeAdminView()
    
    static func create(with viewModel: ChangeAdminChannelViewModel) -> ChangeAdminChannelViewController {
        let vc = ChangeAdminChannelViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("채널 관리자 변경")
        setTableView()
        fetchData()
    }
    
    func setTableView() {
        mainView.memberListTableView.delegate = self
        mainView.memberListTableView.dataSource = self
    }
    
    func fetchData() {
        
        print(#function)
        
        
        viewModel.fetchMemberList { [weak self] value in
            if value {
                print("채널 멤버 리스트 확인. 테이블뷰 리로드")
                self?.mainView.memberListTableView.reloadData()
            } else {
                print("채널 멤버 리스트 없음. 얼럿 띄우고 아웃")
                
                self?.showCustomAlertOneActionViewController(
                    title: "채널 관리자 변경 불가",
                    message: "채널 멤버가 없어 관리자 변경을 할 수 없습니다",
                    completion: {
                        self?.dismiss(animated: false)
                        self?.viewModel.sendAction(event: .goBackChannelSetting)
                    })
            }
            
        }
    }
}


extension ChangeAdminChannelViewController: UITableViewDelegate, UITableViewDataSource {

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberListTableViewCell.description(), for: indexPath) as? MemberListTableViewCell else { return UITableViewCell() }
        
        let userInfo = viewModel.userInfo(indexPath)
        cell.designCell(userInfo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = viewModel.userName(indexPath)
        
        showCustomAlertTwoActionViewController(
            title: "\(name) 님을 관리자로 지정하시겠습니까?",
            message: 
            """
            채널 관리자는 다음과 같은 권한이 있습니다.
            - 채널 이름 또는 설명 변경
            - 채널 삭제
            """,
            okButtonTitle: "확인",
            cancelButtonTitle: "취소") {
                
                self.viewModel.changeAdmin(indexPath: indexPath) { value in
                    if value {
                        self.viewModel.sendAction(event: .goBackChannelSetting)
                        print("토스트메세지 띄워주기토스트메세지 띄워주기토스트메세지 띄워주기토스트메세지 띄워주기토스트메세지 띄워주기")
                        self.dismiss(animated: false)
                        self.dismiss(animated: true)
                    } else {
                        print("실패!")
                    }
                }
                
            } cancelCompletion: {
                self.dismiss(animated: false)
            }

    }
}
