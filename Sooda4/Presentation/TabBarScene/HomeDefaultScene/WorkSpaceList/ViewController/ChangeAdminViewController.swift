//
//  ChangeAdminViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import UIKit

class ChangeAdminViewController: BaseViewController {
    
    var viewModel: ChangeAdminViewModel!
    let mainView = ChangeAdminView()
    
    
    static func create(with viewModel: ChangeAdminViewModel) -> ChangeAdminViewController {
        let vc = ChangeAdminViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setTableView()
        fetchData()
    }
    
    func setNavigation() {
        navigationItem.title = "워크스페이스 관리자 변경"
        if let sheetPresentationController {
            sheetPresentationController.prefersGrabberVisible = true
        }
        
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
        mainView.memberListTableView.delegate = self
        mainView.memberListTableView.dataSource = self
    }
    
    func fetchData() {
        viewModel.fetchMemberList { [weak self] value in
            if value {
                print("워크스페이스 멤버 리스트 확인. 테이블뷰 리로드")
                self?.mainView.memberListTableView.reloadData()
            } else {
                print("워크스페이스 멤버 리스트 없다. 얼럿 띄워주기")
                self?.showCustomAlertOneActionViewController(
                    title: "워크스페이스 관리자 변경 불가",
                    message: "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 워크스페이스에 초대해보세요") {
                        self?.dismiss(animated: false)
                        self?.viewModel.sendAction(event: .goBackWorkSpaceList(changeSuccess: false))
                    }
                // 얼럿 띄워주기 : 권한 줄 멤버가 없다
            }
            
        }
    }
}

extension ChangeAdminViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        print(indexPath)
        let name = viewModel.userName(indexPath)
        
        showCustomAlertTwoActionViewController(
            title: "\(name) 님을 관리자로 지정하시겠습니까?",
            message:
            """
            워크스페이스 관리자는 다음과 같은 권한이 있습니다
            - 워크스페이스 이름 또는 설명 변경
            - 워크스페이스 삭제
            - 워크스페이스 멤버 초대
            """,
            okButtonTitle: "확인",
            cancelButtonTitle: "취소") {
                
                self.viewModel.changeAdmin(indexPath: indexPath) { value in
                    if value {
                        self.navigationController?.dismiss(animated: false)
                        
                    } else {
                        // 네트워크 콜 실패
                    }
                }
                
            } cancelCompletion: {
                self.navigationController?.dismiss(animated: false)
            }
    }
}
