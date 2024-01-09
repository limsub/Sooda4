//
//  WorkSpaceModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/8/24.
//

import Foundation

struct WorkSpaceModel {
    let workSpaceId: Int
    let name: String
    let description: String
    let thumbnail: String
    let ownerId: Int
    let createdAt: String 
}


// 워크스페이스 생성
struct MakeWorkSpaceRequestModel {
    let title: String
    let description: String
    let image: Data // UIImage
}
