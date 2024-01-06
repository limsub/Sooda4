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
    
    
    // 근데 에러가 발생하면, data로 넘겨주는 string을 확인해야 한다
    // 그니까 Result<T, String>으로 줘야 하는거 아닌가
    // String? 으로 선언해서, 디코딩이 되지 않는 에러는 nil로 던져줘서 에러처리하기.
    
    // 아니면, 한 번 더 Result<String, Error> 로 감싸서 디코딩 실패하면 원래 에러 메세지를 던져주기.
    // Singl< Result< T, Result<String, Error> > >
    
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
