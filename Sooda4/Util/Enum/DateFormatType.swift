//
//  DateFormatType.swift
//  Sooda4
//
//  Created by 임승섭 on 1/11/24.
//

import Foundation

enum DateFormatType: String {
    
    case toAPI = "yyyy-MM-dd HH:mm:ss" 
    case fullWithDot = "yy. MM. dd"
    
    case fromAPI = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    case timeAMPM = "hh:mm a"
    
    case monthday = "M/d"
    
    
    case dmCellNotToday = "yyyy년 M월 d일"
    case dmCellToday = "a hh:mm"
}
