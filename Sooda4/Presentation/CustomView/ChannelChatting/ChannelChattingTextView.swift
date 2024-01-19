//
//  ChannelChattingTextView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/18/24.
//

import UIKit


class ChannelChattingTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.frame = CGRect(x: 0, y: 0, width: 275, height: 0)
        self.backgroundColor = .cyan
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = .appFont(.body)
    
    }
}
