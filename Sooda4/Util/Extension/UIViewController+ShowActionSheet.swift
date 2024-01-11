//
//  UIViewController+ShowActionSheet.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import UIKit

extension UIViewController {
    
    func showActionSheetOneSection(title: String, completion: @escaping () -> Void) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstButton = UIAlertAction(title: title, style: .default) { _ in
            completion()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(firstButton)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    
    func showActionSheetFourSection(
        firstTitle: String,
        firstCompletion: @escaping () -> Void,
        secondTitle: String,
        secondCompletion: @escaping () -> Void,
        thirdTitle: String,
        thirdCompletion: @escaping () -> Void,
        fourthTitle: String,
        fourthCompletion: @escaping () -> Void
    ) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstButton = UIAlertAction(title: firstTitle, style: .default) { _ in firstCompletion() }
        
        let secondButton = UIAlertAction(title: secondTitle, style: .default) { _ in secondCompletion() }
        
        let thirdButton = UIAlertAction(title: thirdTitle, style: .default) { _ in thirdCompletion() }
        
        let fourthButton = UIAlertAction(title: fourthTitle, style: .default) { _ in fourthCompletion() }
        
        
        actionSheet.addAction(firstButton)
        actionSheet.addAction(secondButton)
        actionSheet.addAction(thirdButton)
        actionSheet.addAction(fourthButton)
        
        present(actionSheet, animated: true)
    }
    
}
