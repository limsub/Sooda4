//
//  MakeWorkSpaceRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import Foundation
import RxSwift
import RxCocoa

class MakeWorkSpaceRepository: MakeWorkSpaceRepositoryProtocol {
    // (1). 워크스페이스 생성
    func makeWorkSpaceRequest(_ requestModel: MakeWorkSpaceRequestModel) -> Single<Result<WorkSpaceModel, NetworkError>> {
        
        // 1. requestDTO 변환
        let dto = MakeWorkSpaceRequestDTO(
            name: requestModel.name,
            description: requestModel.description,
            image: requestModel.image
        )
        
        // 2. 요청
        return NetworkManager.shared.requestMultiPart(
            type: WorkSpaceInfoDTO.self,
            api: .makeWorkSpace(dto)
        )
        .map { result in
            switch result {
            case .success(let dtoData):
                let responseModel = dtoData.toDomain()
                return .success(responseModel)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    // (2). 워크스페이스 편집
    func editWorkSpaceRequest(_ requestModel: EditWorkSpaceRequestModel) -> Single<Result<WorkSpaceModel, NetworkError>> {
        
        // 1. requestDTO 변환
        let dto = EditWorkSpaceRequestDTO(
            workSpaceId: requestModel.workSpaceId,
            name: requestModel.name,
            description: requestModel.description,
            image: requestModel.image
        )
        
        // 2. 요청
        return NetworkManager.shared.requestMultiPart(
            type: WorkSpaceInfoDTO.self,
            api: .editWorkSpace(dto)
        )
        .map { result in
            switch result {
            case .success(let dtoData):
                let responseModel = dtoData.toDomain()
                return .success(responseModel)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
}
