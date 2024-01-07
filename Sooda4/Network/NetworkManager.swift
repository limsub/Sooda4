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
    
    func request<T: Decodable>(type: T.Type, api: NetworkRouter) -> Single< Result<T, NetworkError> > {
        
        
        return Single< Result<T, NetworkError> >.create { single in
            
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
                        
                        // 디코딩이 되는지 체크
                        print(response.data)
                        
//                        single(.success(.failure(error)))
                    }
                }
            
            
            return Disposables.create()
        }
    }
    
    
    // 빈 데이터가 응답으로 오는 경우 (ex. 이메일 유효성 검사)
    // -> statusCode로 성공 실패 구분.
    func requestEmptyResponse(api: NetworkRouter) -> Single< Result<String, NetworkError> > {
        
        return Single< Result<String, NetworkError> >.create { single in
            
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
                            
                            // ErrorResponse 타입으로 디코딩 성공
                            if let errorCode = self.decodingErrorResponse(from: response.data) {
                                print("(Single - EmptyResponse) 에러 디코딩 성공")
                                let e = NetworkError(errorCode)
                                single(.success(.failure(e)))
                            }
                            
                            // ErrorResponse 타입으로 디코딩 실패
                            else {
                                print("(Single - EmptyResponse) 에러 디코딩 실패")
                                
                                let errorDescription = error.localizedDescription
                                let e = NetworkError(errorDescription)
                                single(.success(.failure(e)))
                            }
                        }
                    }
                }
            return Disposables.create()
        }
        
    }
    
    
    
    func decodingErrorResponse(from jsonData: Data?) -> String? {
        
        guard let jsonData else { return nil }
        
        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: jsonData) {
            
            return errorResponse.errorCode  // 디코딩 성공
        }
       
        return nil  // 디코딩 실패
    }
}
