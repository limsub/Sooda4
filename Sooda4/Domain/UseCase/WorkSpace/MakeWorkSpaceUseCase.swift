//
//  MakeWorkSpaceUseCase.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

protocol MakeWorkSpaceUseCaseProtocol {
    /* === 네트워크 === */
    func makeWorkSpaceRequest(_ requestModel: MakeWorkSpaceRequestModel) -> Single< Result< WorkSpaceModel, NetworkError> >
    func myOneWorkSpaceInfoRequest(_ requestModel: Int) -> Single<Result<MyOneWorkSpaceModel, NetworkError>>
    func editWorkSpaceRequest(_ requestModel: EditWorkSpaceRequestModel) -> Single< Result<WorkSpaceModel, NetworkError> >
}

class MakeWorkSpaceUseCase: MakeWorkSpaceUseCaseProtocol {
    
    // 1. repo
    let makeWorkSpaceRepository: MakeWorkSpaceRepositoryProtocol
    
    // 2. init
    init(makeWorkSpaceRepository: MakeWorkSpaceRepositoryProtocol) {
        self.makeWorkSpaceRepository = makeWorkSpaceRepository
    }
    
    // 3. 프로토콜 메서드 (네트워크)
    func makeWorkSpaceRequest(_ requestModel: MakeWorkSpaceRequestModel) -> Single<Result<WorkSpaceModel, NetworkError>> {
        return makeWorkSpaceRepository.makeWorkSpaceRequest(requestModel)
    }
    
    func editWorkSpaceRequest(_ requestModel: EditWorkSpaceRequestModel) -> Single<Result<WorkSpaceModel, NetworkError>> {
        return makeWorkSpaceRepository.editWorkSpaceRequest(requestModel)
    }
    
    func myOneWorkSpaceInfoRequest(_ requestModel: Int) -> Single<Result<MyOneWorkSpaceModel, NetworkError>> {
        return makeWorkSpaceRepository.myOneWorkSpaceInfoRequest(requestModel)
    }
    
    // 4. 비즈니스 로직
    func loadImageData(endURLString: String) -> Single< Result<Data, Error> > {
        
        return Single.create { single in
            let imageURLString = APIKey.baseURL + endURLString
            let imageURL = URL(string: imageURLString)
            
            let header = [
                "Authorization": UserDefaults.standard.string(forKey: "accessToken")!, // * 임시
                "SesacKey": APIKey.key
            ]
            
            let modifier = AnyModifier { request in
                var modifiedRequest = request
                for (key, value) in header {
                    modifiedRequest.headers.add(name: key, value: value)
                }
                return modifiedRequest
            }
            
            KingfisherManager.shared.retrieveImage(with: imageURL!, options: [.requestModifier(modifier)]) { result  in
                
                switch result {
                case .success(let result):
                    if let imageData = result.data() {
                        single(.success(.success(imageData)))
                    } else {
                        single(.success(.failure(NSError(domain: "Image data is nil", code: 0, userInfo: nil))))
                    }
                    
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}
