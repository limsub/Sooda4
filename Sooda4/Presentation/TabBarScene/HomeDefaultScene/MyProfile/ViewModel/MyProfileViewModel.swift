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
    
    private var disposeBag = DisposeBag()
    
    
    struct Input {
        let loadData: PublishSubject<Void>
    }
    
    struct Output {
        let b: PublishSubject<Int>
    }
    
    func transform(_ input: Input) -> Output {
        let b = PublishSubject<Int>()
        
        
//        input.loadData
//            .flatMap {
//
//            }
//            .subscribe(with: self) { owner , _ in
//                <#code#>
//            }
//            .disposed(by: disposeBag)
        
        
        return Output(
            b: b
        )
    }
    
    
    
}


// event
extension MyProfileViewModel {
    
}
