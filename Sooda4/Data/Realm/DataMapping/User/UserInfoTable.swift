//
//  UserInfoTable.swift
//  Sooda4
//
//  Created by 임승섭 on 1/24/24.
//

import Foundation
import RealmSwift

class UserInfoTable: Object {
    
    @Persisted(primaryKey: true) var user_id: Int
    
    @Persisted var user_name: String
    @Persisted var user_email: String
    @Persisted var user_image: String?
}

extension UserInfoTable {
    
    convenience init(_ model: UserInfoDTO) {
        self.init()
        
        self.user_id = model.user_id
        self.user_name = model.nickname
        self.user_email = model.email
        self.user_image = model.profileImage
    }
}

extension UserInfoTable {
    
    func toDomain() -> UserInfoModel {
        return .init(
            userId: self.user_id,
            email: self.user_email,
            nickname: self.user_name,
            profileImage: self.user_image
        )
    }
}
