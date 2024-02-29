//
//  IamPortDTO.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import Foundation

struct PortOneValidationRequestDTO: Encodable {
    let imp_uid: String
    let merchant_uid: String
}

struct PortOneValidataionResponseDTO: Decodable {
    let billing_id: Int
    let merchant_uid: String
    let amount: Int
    let sesacCoin: Int
    let success: Bool
    let createdAt: String
}


struct SeSACItemResponseDTO: Decodable {
    let item: String
    let ammount: String
    
}

typealias SeSACItemListResponseDTO = [SeSACItemResponseDTO]
