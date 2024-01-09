////
////  MakeWorkSpaceRepository.swift
////  Sooda4
////
////  Created by 임승섭 on 1/9/24.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//class MakeWorkSpaceRepository: MakeWorkSpaceRepositoryProtocol {
//    // (1). 워크스페이스 생성
//    func makeWorkSpaceRequest(_ requestModel: MakeWorkSpaceRequestModel) -> Single<Result<WorkSpaceModel, NetworkError>> {
//        
//        // 1. requestDTO 변환
//        let dto = MakeWorkSpaceRequestDTO(
//            name: requestModel.name,
//            description: requestModel.description,
//            image: requestModel.image
//        )
//        
//        // 2. 요청
////        return NetworkManager.shared
//    }
//}
