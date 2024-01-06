//
//  NetworkRouter.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
    
    /* === 1. case === */
    case checkValidEmail(_ sender: CheckEmailValidationRequestDTO)// DTO
    
    
    /* === 2. path === */
    var path: String {
        switch self {
        case .checkValidEmail:
            return "/v1/users/validation/email"
        }
    }
    
    
    /* === 3. header === */
    var header: HTTPHeaders {
        switch self {
        case .checkValidEmail:
            return [
                "Content-Type": "application/json",
                "SesacKey": APIKey.key
            ]
        }
    }
    
    
    /* === 4. method === */
    var method: HTTPMethod {
        switch self {
        case .checkValidEmail:
            return .post
        }
    }
    
    
    /* === 5. parameter === */
    var parameter: [String: Any] {
        switch self {
        case .checkValidEmail(let sender):
            return [
                "email": sender.email
            ]
            
        default:
            return [:]
        }
    }
    
    
    /* === 6. query === */
    var query: [String: String] {
        switch self {
        default:
            return [:]
        }
    }
    
    
    /* === 7. asURLRequest === */
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: APIKey.baseURL + path)!
        
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method
        
        // paramter
        if method == .post || method == .put {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
            request.httpBody = jsonData
            
            return request
        }
        
        return request
    }
}
