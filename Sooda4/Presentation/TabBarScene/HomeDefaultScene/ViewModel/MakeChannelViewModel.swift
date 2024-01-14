//
//  MakeChannelViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class MakeChannelViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    private let workSpaceId: Int
    
    init(workSpaceId: Int) {
        self.workSpaceId = workSpaceId
    }
    
    struct Input {
        let nameText: ControlProperty<String>
        let descriptionText: ControlProperty<String>
        
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        
        let result: PublishSubject<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let result = PublishSubject<Bool>()
        
        return Output(result: result)
    }
}
