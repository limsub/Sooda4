//
//  ChannelSettingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/15/24.
//

import UIKit
import RxSwift
import RxCocoa


class ChannelSettingViewController: BaseViewController {
    
    private let mainView = ChannelSettingView()
    private var viewModel: ChannelSettingViewModel!
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: ChannelSettingViewModel) -> ChannelSettingViewController {
        let vc = ChannelSettingViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    
    // input event
    private var buttonClicked = PublishSubject<IndexPath>()  // 버튼 4개에 대해 연결
    private var leaveChannel = PublishSubject<Void>()   // 채널 나가기
    private var deleteChannel = PublishSubject<Void>()  // 채널 삭제
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        fetchData()
        bindVM()
    }
    
    func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
        
    func fetchData() {
        viewModel.fetchData {
            self.mainView.tableView.reloadData()
        }
    }
    
    func reloadData(workSpaceId: Int, channelName: String?) {
        
        // 채널 편집으로 돌아올 때는 새로운 채널 이름을 물고 오고,
        // 관리자 변경으로 돌아올 때는 nil을 넣어서 온다.
        if let channelName {
            viewModel.channelName = channelName
        }
        
        viewModel.fetchData { [weak self] in
            self?.mainView.tableView.reloadData()
            
        }
    }
    
    func bindVM() {
        let input = ChannelSettingViewModel.Input(
            buttonClicked: buttonClicked,
            leaveChannel: leaveChannel,
            deleteChanel: deleteChannel
        )
        
        let output = viewModel.transform(input)
        
        output.showPopupLeaveChannel
            .subscribe(with: self) { owner , value in
                owner.showPopupLeaveChannel(value)
            }
            .disposed(by: disposeBag)
        
        output.showPopupDeleteChannel
            .subscribe(with: self) { owner , _ in
                owner.showPopupDeleteChannel()
            }
            .disposed(by: disposeBag)
        
    }
    
}


// tableView protocol
extension ChannelSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = viewModel.sectionType(indexPath: indexPath)
        
        switch sectionType {
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingChannelInfoTableViewCell.description()) as? ChannelSettingChannelInfoTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.channelInfoForInfoCell()
            cell.designCell(name: data.0, description: data.1 ?? "")
            
            return cell
        case .memberFolding:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingMemberFoldingTableViewCell.description()) as? ChannelSettingMemberFoldingTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.memberCountForFoldingCell()
            cell.designCell(count: data)
            
            return cell
        case .members:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingMembersTableViewCell.description()) as? ChannelSettingMembersTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.memberInfoForMembersCell()
            cell.items = data
            cell.reloadCollectionView()
            
            return cell
        case .button:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelSettingHandleChannelTableViewCell.description()) as? ChannelSettingHandleChannelTableViewCell else { return UITableViewCell() }
            
            let data = viewModel.buttonDataForButtonCell(indexPath: indexPath)
            cell.designCell(text: data.0, isRed: data.1)
            
            
            cell.handleButton.rx.tap
                .subscribe(with: self) { owner , _ in
                    owner.buttonClicked.onNext(indexPath)
                }
                .disposed(by: cell.disposeBag)
            
           
            return cell
        }

    }
    

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sectionType = viewModel.sectionType(indexPath: indexPath)
        
        switch sectionType {
        case .info:
            return UITableView.automaticDimension
        case .memberFolding:
            return 56
        case .members:
            return UITableView.automaticDimension
        case .button:
            return 52
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.toggleOpenValue(indexPath: indexPath) {
            self.mainView.tableView.reloadSections([indexPath.section], with: .none)
        }
        
    }
    
}


// show Popup
extension ChannelSettingViewController {
    
    func showPopupLeaveChannel(_ isAdmin: Bool) {
        if isAdmin {
            showCustomAlertOneActionViewController(
                title: "채널에서 나가기",
                message: "회원님은 채널 관리자입니다. 채널 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.") {
                    self.dismiss(animated: false)
                }
            
        } else {
            showCustomAlertTwoActionViewController(
                title: "채널에서 나가기",
                message: "나가기를 하면 채널 목록에서 삭제됩니다",
                okButtonTitle: "나가기",
                cancelButtonTitle: "취소") {
                    self.dismiss(animated: false)
                    self.leaveChannel.onNext(())
                } cancelCompletion: {
                    self.dismiss(animated: false)
                }

        }
    }
    
    func showPopupDeleteChannel() {
        showCustomAlertTwoActionViewController(
            title: "채널 삭제",
            message: "정말 이 채널을 삭제하시겠습니까? 삭제 시 멤버/채팅 등 채널 내의 모든 정보가 삭제되며 복구할 수 없습니다",
            okButtonTitle: "삭제",
            cancelButtonTitle: "취소") {
                self.dismiss(animated: false)
                self.deleteChannel.onNext(())
            } cancelCompletion: {
                self.dismiss(animated: false)
            }

    }
    
}

