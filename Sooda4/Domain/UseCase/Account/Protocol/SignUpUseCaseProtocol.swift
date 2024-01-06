//
//  SignUpUseCaseProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpUseCaseProtocol {
    
    func checkValidEmail(_ email: String) -> Single< Result<String, Error> >
    
}
