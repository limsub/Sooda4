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
    
    var vcViewDidLoad: ControlEvent<Void>?
    
    private let workSpaceUseCase: WorkSpaceUseCaseProtocol
    
    init(workSpaceUseCase: WorkSpaceUseCaseProtocol) {
        self.workSpaceUseCase = workSpaceUseCase
    }
    
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let menuButtonClicked: ControlEvent<Void>?
        
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
        

        
        return Output(
            items: items
        )
    }
}
