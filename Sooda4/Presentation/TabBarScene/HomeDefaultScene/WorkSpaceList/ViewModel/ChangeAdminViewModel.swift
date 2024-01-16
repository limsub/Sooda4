//
//  ChangeAdminViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/12/24.
//

import Foundation

class ChangeAdminViewModel {
    
    var didSendEventClosure: ( (ChangeAdminViewModel.Event) -> Void)?
    
    var workSpaceId: Int
    var handleWorkSpaceUseCase: HandleWorkSpaceUseCaseProtocol  // WorkSpaceList 코디가 쓰는 UseCase를 받아올 것
    
    var items: [WorkSpaceUserInfo] = []
    
    init(workSpaceId: Int,
         handleWorkSpaceUseCase: HandleWorkSpaceUseCaseProtocol
    ) {
        self.workSpaceId = workSpaceId
        self.handleWorkSpaceUseCase = handleWorkSpaceUseCase
    }
    
    func fetchMemberList(completion: @escaping (Bool) -> Void) {
        
        handleWorkSpaceUseCase.workSpaceMembersRequest(self.workSpaceId) { response in
            
            switch response {
            case .success(let model):
                
                // 본인이 아닌 사람들 리스트
                self.items = model.filter {
                    $0.userId != KeychainStorage.shared._id
                }
                
                completion(!self.items.isEmpty)
                
            case .failure(let error):
                print("에러났슈 : \(error.localizedDescription)")
            }
            

        }
    }
    
    func changeAdmin(indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        
        let requestModel = ChangeAdminRequestModel(
            workSpaceId: workSpaceId,
            newAdminId: items[indexPath.row].userId
        )
        
        handleWorkSpaceUseCase.changeAdminWorkSpace(
            requestModel
        ) { response in
            
            switch response {
            case .success(let model):
                print("성공")
                
                completion(true)    // view dismiss
                
                self.didSendEventClosure?(.goBackWorkSpaceList(changeSuccess: true))
                
            case .failure(let networkError):
                print("에러났슈 : \(networkError.localizedDescription)")
                completion(false)
                
            }
            
            
            
                print(response)
            
            
        }
    }
    
}


// TableView 관련 로직 및 데이터
extension ChangeAdminViewModel {
    func numberOfRows() -> Int {
        return items.count
    }
    func userInfo(_ indexPath: IndexPath) -> WorkSpaceUserInfo {
        return items[indexPath.row]
    }
    func userName(_ indexPath: IndexPath) -> String {
        return items[indexPath.row].nickname
    }
}


// 불가피하게 뷰컨에서 코디네이터한테 이벤트 전달해야 할 때가 있다
extension ChangeAdminViewModel {
    func sendAction(event: Event) {
        didSendEventClosure?(event)
    }
}


extension ChangeAdminViewModel {
    enum Event {
        case goBackWorkSpaceList(changeSuccess: Bool)
    }
}
