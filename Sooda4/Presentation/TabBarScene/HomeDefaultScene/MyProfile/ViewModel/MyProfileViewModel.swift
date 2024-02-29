//
//  MyProfileViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import Foundation
import RxSwift
import RxCocoa

class MyProfileViewModel: BaseViewModelType {
    
    
    struct Input {
        let a: ControlEvent<Void>
    }
    
    struct Output {
        let b: PublishSubject<Int>
    }
    
    func transform(_ input: Input) -> Output {
        let b = PublishSubject<Int>()
        
        return Output(
            b: b
        )
    }
    
}


// event
extension MyProfileViewModel {
    
}
