//
//  NetworkManager.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func request<T: Decodable>(type: T.Type, api: NetworkRouter) -> Single< Result<T, Error> > {
        
        
        return Single< Result<T, Error> >.create { single in
            
            AF.request(api)
                .validate()
                .responseDecodable(of: T.self) { response in
                    
                    let statusCode = response.response?.statusCode
                    
                    switch response.result {
                    case .success(let data):
                        print("(Single) 네트워크 통신 성공")
                        single(.success(.success(data)))
                        
                    case .failure(let error):
                        print("(Single) 네트워크 통신 실패")
                        
                        single(.success(.failure(error)))
                    }
                }
            
            
            return Disposables.create()
        }
    }
    
    
    // 빈 데이터가 응답으로 오는 경우 (ex. 이메일 유효성 검사)
    // -> statusCode로 성공 실패 구분.
    func requestEmptyResponse(api: NetworkRouter) -> Single< Result<String, Error> > {
        
        return Single< Result<String, Error> >.create { single in
            
            AF.request(api)
                .validate()
                .response { response in
                    let statusCode = response.response?.statusCode
                    
                    print("code : ", statusCode)
                    
                 
                    if statusCode == 200 {
                        print("(Single - EmptyResponse) 네트워크 통신 성공")
                        single(.success(.success("good")))
                    }
                    else {
                        let result = response.result
                        
                        if case .failure(let error) = result {
                            print("(Single - EmptyResponse) 네트워크 통신 실패")
                            
                            // 실패이면, 서버에서 받은 데이터를 분석해서, 에러 분기 처리
                            if let data = response.data {
                                if let jsonString = String(data: data, encoding: .utf8) {
                                    print("(Single - EmptyResponse) 서버 응답 데이터(JSON String): \(jsonString)")
                                }
                            }
                            
                            single(.success(.failure(error)))
                        }
                    }
                }
            return Disposables.create()
        }
        
    }
}
