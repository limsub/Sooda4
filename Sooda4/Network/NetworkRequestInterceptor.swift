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
        
        // access token 업데이트
        var urlRequest = urlRequest
        urlRequest.headers.add(
            name: "Authorization",
            value: KeychainStorage.shared.accessToken ?? ""
        )
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        // statusCode를 확인할 수가 없기 때문에, 모든 에러 발생 시 무조건 리프레시 토큰 갱신 네트워크 콜? -> 너무 비효율적이지 않을까
        
        
        guard let dataRequest = request as? DataRequest,
              let originRequest = dataRequest.request else {
            completion(.doNotRetry)
            return
        }
        
        dataRequest.responseData { response  in
            switch response.result {
            case .success(let data):
                // 여기서 데이터를 받으면 내용물 확인해서 걸러주기
                
                break;
                
            case .failure(let error):
                completion(.doNotRetry)
                
                break;
            }
        }
        
        
        
    }
    
}
