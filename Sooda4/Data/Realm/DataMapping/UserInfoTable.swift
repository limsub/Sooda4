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
