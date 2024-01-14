//
//  ExploreChannelViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class ExploreChannelViewModel: BaseViewModelType {
    
    struct Input {
        let a: String
    }
    struct Output {
        let b: String
    }
    
    func transform(_ input: Input) -> Output {
        
        
        
        return Output(b: input.a)
    }
}
