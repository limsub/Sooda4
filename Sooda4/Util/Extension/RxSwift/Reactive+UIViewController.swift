//
//  Reactive+UIViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }.take(1)
        
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { _ in () }
        return ControlEvent(events: source)
    }
}
