//
//  SignUpViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation
import RxSwift
import RxCocoa


class SignUpViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    private let signUpUseCase: SignUpUseCaseProtocol
    
    init(signUpUseCase: SignUpUseCaseProtocol) {
        self.signUpUseCase = signUpUseCase
    }
    
    struct Input {
        let a: ControlEvent<Void>
    }
    
    struct Output {
        let b: String
    }
    
    func transform(_ input: Input) -> Output {
        
        input.a
            .flatMap {
                self.signUpUseCase.checkValidEmail("h")
                
            }
            .subscribe(with: self) { owner, response in
                print(response)
            }
            .disposed(by: disposeBag)
        
        
        return Output(b: "")
    }
    
}
