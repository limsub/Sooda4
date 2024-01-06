//
//  BaseViewModelType.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation

protocol BaseViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    
    func transform(_ input: Input) -> Output
}
