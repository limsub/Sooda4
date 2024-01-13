//
//  WorkSpaceListViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class WorkSpaceListViewModel: BaseViewModelType {
    
    let disposeBag = DisposeBag()
    
    var didSendEventClosure: ( (WorkSpaceListViewModel.Event) -> Void)?
    
    private let workSpaceUseCase: WorkSpaceUseCaseProtocol
    private var selectedWorkSpaceId: Int?   // nil이면 HomeEmpty에서 온걸로
    
    init(workSpaceUseCase: WorkSpaceUseCaseProtocol, selectedWorkSpaceId: Int?) {
        self.workSpaceUseCase = workSpaceUseCase
        self.selectedWorkSpaceId = selectedWorkSpaceId
        
        print("WorkSpaceListViewModel init")
        print(workSpaceUseCase)
        print(selectedWorkSpaceId)
    }
    
    
    struct Input {
        let loadData: PublishSubject<Void>
        let itemSelected: ControlEvent<IndexPath>
        let menuButtonClicked: PublishSubject<Void>?
        
        let addWorkSpaceButtonClicked: ControlEvent<Void>
        let helpButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let items: PublishSubject<[WorkSpaceModel]>
    }
    
    func transform(_ input: Input) -> Output {
        
        
        let items = PublishSubject<[WorkSpaceModel]>()
        
        
        input.loadData
            .flatMap { _ in
                self.workSpaceUseCase.myWorkSpacesRequest()
            }
            .subscribe(with: self) { owner , response  in
                switch response {
                case .success(let model):
                    items.onNext(model)
                case .failure(let error):
                    print("아직 에러처리 안함")
                }
            }
            .disposed(by: disposeBag)
        
        // 메뉴버튼 클릭 -> 관리자 여부 확인 -> actionSheet
        // 메뉴버튼이 클릭되었다는건, 그 워크스페이스는 현재 VM에 저장된 workSpaceId의 워크스페이스라는 뜻. 즉, 그냥 바로 사용한다.
        if input.menuButtonClicked != nil {
            input.menuButtonClicked!
                .withLatestFrom(items)
                .map { value in
                    // workSpaceId를 가진 워크스페이스를 찾고,
                    // 그 워크스페이스의 ownerId가 나인지 판단
                    var check = false
                    value.forEach { workspace in
                        if (workspace.workSpaceId == self.selectedWorkSpaceId) {
                            // * 임시
                            if workspace.ownerId == UserDefaults.standard.integer(forKey: "userID") {
                                check = true
                            }
                        }
                    }
                    
                    return check
               }
            
                .subscribe(with: self) { owner , value in
                    if value {
                        print("내 워크스페이스다")
                        owner.didSendEventClosure?(.showActionSheetForAdmin)
                    } else {
                        print("내 워크스페이스 아니다")
                        owner.didSendEventClosure?(.showActionSheetForGeneral)
                    }

                }
                .disposed(by: disposeBag)
        }
        
        
        // go back
        input.itemSelected
            .withLatestFrom(items) { indexPath, value in
                return value[indexPath.row]
            }
            .subscribe(with: self) { owner , value in
                owner.didSendEventClosure?(.goBackHomeDefault(workSpaceId: value.workSpaceId))
            }
            .disposed(by: disposeBag)
        
        
        // 워크스페이스 추가
        input.addWorkSpaceButtonClicked
            .subscribe(with: self) { owner , _ in
                
                owner.didSendEventClosure?(.presentMakeWorkSpace)
            }
            .disposed(by: disposeBag)
        
        return Output(
            items: items
        )
    }
}


extension WorkSpaceListViewModel {
    func checkSelectedWorkSpace(_ model: WorkSpaceModel) -> Bool {
        return model.workSpaceId == self.selectedWorkSpaceId
    }
    
}

extension WorkSpaceListViewModel {
    enum Event {
        case goBackHomeDefault(workSpaceId: Int)
        
        case showActionSheetForAdmin
        case showActionSheetForGeneral
        
        case presentMakeWorkSpace
    }
}
