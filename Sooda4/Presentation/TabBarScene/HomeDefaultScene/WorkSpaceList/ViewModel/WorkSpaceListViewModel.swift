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
    
    var vcViewDidLoad: ControlEvent<Void>?
    
    private let workSpaceUseCase: WorkSpaceUseCaseProtocol
    private var selectedWorkSpaceId: Int
    
    init(workSpaceUseCase: WorkSpaceUseCaseProtocol, selectedWorkSpaceId: Int) {
        self.workSpaceUseCase = workSpaceUseCase
        self.selectedWorkSpaceId = selectedWorkSpaceId
    }
    
    
    struct Input {
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
        
        // 워크스페이스 배열 네트워크 콜
        if vcViewDidLoad != nil {
            vcViewDidLoad!
                .flatMap {_ in
                    self.workSpaceUseCase.myWorkSpacesRequest()
                }
                .subscribe(with: self) { owner , response in
                    
                    switch response {
                    case .success(let model):
                        items.onNext(model)
                    case .failure(let error):
                        print("에러 예외처리 아직 안함")
                    }
                }
                .disposed(by: disposeBag)
        }
        
        if input.menuButtonClicked != nil {
            input.menuButtonClicked!
                .subscribe(with: self) { owner , _ in
                    print("000")
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
    }
}
