//
//  BaseViewModelType.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    
    func tranform(_ input: Input) -> Output
}
