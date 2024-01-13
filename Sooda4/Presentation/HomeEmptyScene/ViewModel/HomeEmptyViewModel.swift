//
//  HomeEmptyViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/13/24.
//

import Foundation
import RxSwift
import RxCocoa

class HomeEmptyViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    var didSendEventClosure: ( (HomeEmptyViewModel.Event) -> Void )?
    
    
    struct Input {
        let presentWorkSpaceList: ControlEvent<Void>
        
    }
    
    struct Output {
        let presentWorkSpaceList: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        input.presentWorkSpaceList
            .subscribe(with: self) { owner , _ in
                print("0000")
                print(owner.didSendEventClosure)
                owner.didSendEventClosure?(.showWorkSpaceList)
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(
            presentWorkSpaceList: input.presentWorkSpaceList
        )
    }
}

extension HomeEmptyViewModel {
    enum Event {
        case showMakeWorkSpace
        case showWorkSpaceList
    }
}
