//
//  NetworkInterceptor.swift
//  Sooda4
//
//  Created by 임승섭 on 1/16/24.
//

import Foundation
import Alamofire

final class NetworkRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print(" --- adapt --- ")
        
        // access token 업데이트
        var urlRequest = urlRequest
        urlRequest.headers.add(
            name: "Authorization",
            value: KeychainStorage.shared.accessToken ?? ""
        )
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        
        // 내용을 거를 수가 없음 -> 고민해보기
        
        completion(.doNotRetryWithError(error))
        

        
        
    }
    
    struct RefreshResponseDTO: Decodable {
        let accessToken: String
    }
    
    
}



