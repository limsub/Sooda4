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
    
    // Single
    func request<T: Decodable>(
        type: T.Type,
        api: NetworkRouter
    ) -> Single< Result<T, NetworkError> > {
        
        
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
                        print("-----")
                        print(error)
                        print("-----")
                        
                        // ErrorResponse타입으로 디코딩
                        // 성공
                        if let errorCode = self.decodingErrorResponse(from: response.data) {
                            print("(Single) - 에러 디코딩 성공")
                            
                            let e = NetworkError(errorCode)
                            single(.success(.failure(e)))
                        }
                        // 실패
                        else {
                            print("(Single) - 에러 디코딩 실패")
                            let errorDescription = error.localizedDescription
                            let e = NetworkError(errorDescription)
                            single(.success(.failure(e)))
                        }
                        
                    }
                }
            
            
            return Disposables.create()
        }
    }
    
    
    // 빈 데이터가 응답으로 오는 경우 (ex. 이메일 유효성 검사, 워크스페이스 삭제)
    // -> statusCode로 성공 실패 구분.
    func requestEmptyResponse(
        api: NetworkRouter
    ) -> Single< Result<String, NetworkError> > {
        
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
    
    
    // Single + multipart
    func requestMultiPart<T: Decodable>(
        type: T.Type,
        api: NetworkRouter
    ) -> Single< Result<T, NetworkError> > {
        
        print("--------------")
        
        return Single< Result<T, NetworkError> >.create { single in
            
            AF.upload(
                multipartFormData: api.multipart,
                with: api
            )
            .validate()
            .responseDecodable(of: T.self) { response  in
                let statusCode = response.response?.statusCode
                
                switch response.result {
                case .success(let data):
                    print("(Single - Multipart) 네트워크 통신 성공")
                    single(.success(.success(data)))
                    
                case .failure(let error):
                    print("(Single - Multipart) 네트워크 통신 실패")
                    
                    if let errorCode = self.decodingErrorResponse(from: response.data) {
                        print("(Single - Multipart) 에러 디코딩 성공")
                        let e = NetworkError(errorCode)
                        single(.success(.failure(e)))
                    } else {
                        print("(Single - Multipart) 에러 디코딩 실패")
                        let errorDescription = error.localizedDescription
                        let e = NetworkError(errorDescription)
                        single(.success(.failure(e)))
                    }
                }
            
            }
            
            
            return Disposables.create()
        }
    }
    
    
    
    // Completion
    func requestCompletion<T: Decodable>(
        type: T.Type,
        api: NetworkRouter,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        
        AF.request(api)
            .validate()
            .responseDecodable(of: T.self) { response  in
                switch response.result {
                case .success(let data):
                    print("(Completion) 네트워크 통신 성공")
                    completion(.success(data))
                    
                case .failure(let error):
                    print("(Completion) 네트워크 통신 실패")
                    
                    // ErrorResponse 타입으로 디코딩
                    // 디코딩 성공
                    if let errorCode = self.decodingErrorResponse(from: response.data) {
                        print("(Completion) - 에러 디코딩 성공")
                        let e = NetworkError(errorCode)
                        completion(.failure(e))
                    }
                    // 디코딩 실패
                    else {
                        print("(Completion) - 에러 디코딩 실패")
                        let errorDescription = error.localizedDescription
                        let e = NetworkError(errorDescription)
                        completion(.failure(e))
                    }
                    
                }
            }
    }
    
    
    func requestCompletionEmptyResponse(
        api: NetworkRouter,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        AF.request(api)
            .validate()
            .response { response in
                let statusCode = response.response?.statusCode
                
                print("code : ", statusCode)
                
                if statusCode == 200 {
                    print("(Completion - EmptyResponse) 네트워크 통신 성공")
                    completion(.success("good"))
                }
                else {
                    let result = response.result
                    
                    if case .failure(let error) = result {
                        print("(Completion - EmptyResponse) 네트워크 통신 실패")
                        
                        // ErrorResponse 타입으로 디코딩 성공
                        if let errorCode = self.decodingErrorResponse(from: response.data) {
                            print("(Completion - EmptyResponse) 에러 디코딩 성공")
                            let e = NetworkError(errorCode)
                            completion(.failure(e))
                        }
                        
                        // ErrorResponse 타입으로 디코딩 실패
                        else {
                            print("(Completion - EmptyResponse) 에러 디코딩 실패")
                            
                            let errorDescription = error.localizedDescription
                            let e = NetworkError(errorDescription)
                            completion(.failure(e))
                        }
                    }
                }
                
            }
    }
    
    
    
    
    private func decodingErrorResponse(from jsonData: Data?) -> String? {
        
        guard let jsonData else { return nil }
        
        if let errorResponse = try? JSONDecoder().decode(ErrorResponseDTO.self, from: jsonData) {
            
            return errorResponse.errorCode  // 디코딩 성공
        }
       
        return nil  // 디코딩 실패
    }
}
