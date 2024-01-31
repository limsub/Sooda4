//
//  String+FileExtension.swift
//  Sooda4
//
//  Created by 임승섭 on 1/31/24.
//

import Foundation


// FileManager url
// file:///Users/imseungseob/Library/Developer/CoreSimulator/Devices/AB002853-7152-4B14-879C-57942E852E73/data/Containers/Data/Application/957256F6-DEDD-4F6D-8AAF-BBFE353C5E2F/tmp/com.sub.Sooda4-Inbox/PDF_SAMPLE.pdf

// Server url
// /static/channelsChat/1706680645879.pdf

extension String {
    
    // url이 들어왔을 때, 마지막 '/' 기준 뒤 문자열 반환
    func extractFileName() -> String? {
        let components = self.components(separatedBy: "/")
        
        guard let lastComponent = components.last else { return nil }
        
        return lastComponent
    }
    
    
    // 파일 확장자
    func fileExtension() -> FileExtension? {
        guard let lastIdx = self.lastIndex(of: ".") else { return nil }
        
        return FileExtension(rawValue: String(self[lastIdx...].dropFirst()))
    }
    
}
