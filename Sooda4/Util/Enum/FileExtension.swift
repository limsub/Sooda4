//
//  FileExtension.swift
//  Sooda4
//
//  Created by 임승섭 on 1/30/24.
//

import Foundation

enum FileExtension: String, CaseIterable {
    
    case pdf
    case gif
    case avi
    case zip
    case mp3
    
    case doc
    case ppt
    case txt
    case mov
    
    case jpeg

    
    var extensionStr: String {
        return ".\(self.rawValue)"
    }
    
    var imageName: String {
        return "fileEx_\(self.rawValue)"
    }
    
    var mimeType: String {
        switch self {
        case .pdf:
            return "application/pdf"
        case .gif:
            return "image/gif"
        case .avi:
            return "video/avi"
        case .zip:
            return "application/zip"
        case .mp3:
            return "audio/mp3"
            
        case .doc:
            return "application/msword"
        case .ppt:
            return "application/vnd.ms-powerpoint"
        case .txt:
            return "text/plain"
        case .mov:
            return "video/quicktime"
            
        case .jpeg:
            return "image/jpeg"
        }
    }
}
