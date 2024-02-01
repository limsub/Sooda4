//
//  ChangeAdminChannelViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/17/24.
//

import Foundation
import RxSwift
import RxCocoa

class ChangeAdminChannelViewModel {
    
    var didSendEventClosure: ( (ChangeAdminChannelViewModel.Event) -> Void )?
        
    private let workSpaceId: Int
    private let channelName: String
    
    private var handleChannelUseCase: HandleChannelUseCaseProtocol

    private var items: [UserInfoModel] = []
    
    init(workSpaceId: Int, channelName: String, handleChannelUseCase: HandleChannelUseCaseProtocol) {
        self.workSpaceId = workSpaceId
        self.channelName = channelName
        self.handleChannelUseCase = handleChannelUseCase
    }
    

    
    func fetchMemberList(completion: @escaping (Bool) -> Void) {
        
        let requestModel = ChannelDetailRequestModel(
            workSpaceId: workSpaceId,
            channelName: channelName
        )
        
        handleChannelUseCase.channelMembersRequest(requestModel) { response in
            switch response {
            case .success(let model):
                // 본인이 아닌 사람들 리스트
                self.items = model.filter {
                    $0.userId != KeychainStorage.shared._id
                }
                
            case .failure(let networkError):
                print("에러났슈 : \(networkError)")
            }
            
            completion(!self.items.isEmpty)
        }
    }
    
    func changeAdmin(indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        
        let requestModel = ChangeAdminChannelRequestModel(
            workSpaceId: workSpaceId,
            nextAdminUserId: items[indexPath.row].userId,
            channelName: channelName
        )
        
        
        handleChannelUseCase.chanegAdminChannelRequest(
            requestModel) { response in
                switch response {
                case .success:
                    print("성공")
                    completion(true)
                    self.didSendEventClosure?(.goBackChannelSetting)
                    
                case .failure(let networkError):
                    print("에러났슈 : \(networkError)")
                    completion(false)
                }
            }
    }
}


// 불가피하게 뷰컨에서 코디네이터한테 이벤트 전달해야 할 때가 있다
extension ChangeAdminChannelViewModel {
    func sendAction(event: Event) {
        didSendEventClosure?(event)
    }
}

// Event
extension ChangeAdminChannelViewModel {
    enum Event {
        case goBackChannelSetting
    }
}


// TableView
extension ChangeAdminChannelViewModel {
    func numberOfRows() -> Int {
        return items.count
    }
    func userInfo(_ indexPath: IndexPath) -> UserInfoModel {
        return items[indexPath.row]
    }
    func userName(_ indexPath: IndexPath) -> String {
        return items[indexPath.row].nickname
    }
}
