//
//  FileExtension.swift
//  Sooda4
//
//  Created by 임승섭 on 1/30/24.
//

import Foundation

enum FileExtension: String, CaseIterable {
    case doc
    case gif
    case pdf
    case ppt
    case txt
    case zip
    case mov
    case mp3
    case avi
    
    var extensionStr: String {
        return ".\(self.rawValue)"
    }
    
    var imageName: String {
        return "fileEx_\(self.rawValue)"
    }
}
