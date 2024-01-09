//
//  NetworkRouter.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
    
    /* ========== case ========== */
    /* === USER === */
    case checkValidEmail(_ sender: CheckEmailValidationRequestDTO)
    case requestSignUp(_ sender: SignUpRequestDTO)
    case signInRequest(_ sender: SignInRequestDTO)
    
    
    /* === WORKSPACE === */
    case makeWorkSpace(_ sender: MakeWorkSpaceRequestDTO)
    case myWorkSpaces
    
    
    
    /* === 2. path === */
    var path: String {
        switch self {
        case .checkValidEmail:
            return "/v1/users/validation/email"
        case .requestSignUp:
            return "/v1/users/join"
        case .signInRequest:
            return "/v1/users/login"
            
            
        case .makeWorkSpace:
            return "/v1/workspaces"
        case .myWorkSpaces:
            return "/v1/workspaces"
        }
    }
    
    
    /* === 3. header === */
    var header: HTTPHeaders {
        switch self {
        case .makeWorkSpace:
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": APIKey.sample,
                "SesacKey": APIKey.key
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": APIKey.sample,
                "SesacKey": APIKey.key
            ]
        }
    }
    
    
    /* === 4. method === */
    var method: HTTPMethod {
        switch self {
        // USER
        case .checkValidEmail, .requestSignUp, .signInRequest:
            return .post
        
        // WORKSPACE
        case .makeWorkSpace:
            return .post
        case .myWorkSpaces:
            return .get
        }
    }
    
    
    /* === 5. parameter === */
    var parameter: [String: Any] {
        switch self {
        case .checkValidEmail(let sender):
            return [
                "email": sender.email
            ]
        case .requestSignUp(let sender):
            return [
                "email": sender.email,
                "password": sender.password,
                "nickname": sender.nickname,
                "phone": sender.phone,
                "deviceToken": sender.deviceToken
            ]
        case .signInRequest(let sender):
            return [
                "email": sender.email,
                "password": sender.password,
                "deviceToken": sender.deviceToken
            ]
            
            
        // WORKSPACE
        case .makeWorkSpace(let sender):
            return [
                "name": sender.name,
                "description":  sender.description,
                "image": sender.image
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
    
    
    /* === 7. MultiPart Form Data === */
    var multipart: MultipartFormData {
        
        if self.header["Content-Type"] == "multipart/form-data" {
            return makeMultiPartFormData()
        }
        
        return MultipartFormData()
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
    
    
    func makeMultiPartFormData() -> MultipartFormData {
        
        let multipartFormData = MultipartFormData()
        
        for (key, value) in self.parameter {
            // 이미지 데이터인 경우
            if let imageData = value as? Data {
                multipartFormData.append(
                    imageData,
                    withName: key,
                    fileName: "image.jpeg",
                    mimeType: "image/jpeg"
                )
                
            }
            
            else {
                multipartFormData.append(
                    "\(value)".data(using: .utf8)!,
                    withName: key
                )
            }
        }
        
        return multipartFormData
    }
}
